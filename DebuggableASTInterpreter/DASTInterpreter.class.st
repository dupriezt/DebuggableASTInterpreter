"
I can interpret a program represented as an AST tree
"
Class {
	#name : #DASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'currentNode',
		'currentContext',
		'process',
		'debuggerService',
		'stackTop',
		'semaphore',
		'exceptions',
		'signalExceptions'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessors }
DASTInterpreter >> currentContext [
	^ currentContext.
]

{ #category : #execution }
DASTInterpreter >> currentNode [
	^ currentNode
]

{ #category : #evaluation }
DASTInterpreter >> evaluate [
	| value |
	semaphore := Semaphore new: 0.
	currentContext := DASTContext new.
	process := [value := [[self visit: currentNode ] 
									on: Error
									do: [ :e | self exceptions add: e . 
												 "Transcript show: e asString; cr ." 
												 semaphore signal. 
												 self signalExceptions ifTrue: [ e pass ] ]]
					ensure: [semaphore signal]] fork.
	semaphore wait.
	^ value
]

{ #category : #accessors }
DASTInterpreter >> exceptions [
	^ exceptions ifNil: [ exceptions := OrderedCollection new ]
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [
	currentNode := aRBNode.
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode debuggerService: aDebuggerService [
	currentNode := aRBNode.
	debuggerService := aDebuggerService.
]

{ #category : #'control-flow' }
DASTInterpreter >> onTracePoint: aRBNode [
	"if debuggerService is not set, then it's not necessary to implement stepping 
	and this message does nothing"
	debuggerService ifNil: [ ^ self ].
	debuggerService onTracePoint: aRBNode.

	
]

{ #category : #execution }
DASTInterpreter >> process [ 
	^process
]

{ #category : #'control-flow' }
DASTInterpreter >> resumeProcess [
	"the debugger service thread will call this method for resuming the interpreter process" 
	semaphore signal.
	semaphore wait.
	
]

{ #category : #execution }
DASTInterpreter >> run [
	
	process 
		ifNil: [ self evaluate "this message will initialize the process that evaluates the tree"]
		ifNotNil: [ self resumeProcess  ].
	
]

{ #category : #flagging }
DASTInterpreter >> signalExceptions [
	^ signalExceptions ifNil: [ signalExceptions := true ]
]

{ #category : #flagging }
DASTInterpreter >> signalExceptions: aBoolean [
	signalExceptions := aBoolean
]

{ #category : #evaluation }
DASTInterpreter >> stackTop [
	^stackTop
]

{ #category : #'control-flow' }
DASTInterpreter >> suspendProcess [
	"the thread that interprets will call this method when a tracePoint is reached" 
	semaphore signal.
	semaphore wait.
	
]

{ #category : #evaluation }
DASTInterpreter >> visit: aRBNode [
	| value previousNode |
	previousNode := currentNode.
	currentNode := aRBNode.
	
	value := aRBNode acceptVisitor: self.
	"Transcript cr;cr;show: 'visiting';space; show:(aRBNode asString);cr ."
	stackTop := value.
	currentNode := previousNode.
	^ value
]

{ #category : #visiting }
DASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	| name value |
	self assert: (aRBAssignmentNode children size = 2).
	name := self visit: aRBAssignmentNode children last.
	value := self visit: aRBAssignmentNode children first.
	self onTracePoint: aRBAssignmentNode.
	"if the node is a tracepoint, the action associated to itself is excecuted after the break"
	self currentContext at: name put: value.
	^ value
	
]

{ #category : #visiting }
DASTInterpreter >> visitBlockNode: aRBBlockNode [ 
	self onTracePoint: aRBBlockNode.
	
	"if the node is a tracepoint, the action associated to itself is excecuted after the break"
	^ DASTClosure new initializeWith: aRBBlockNode outerContext: currentContext.
	
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 
	self onTracePoint: aRBLiteralValueNode.
	^ aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	| arguments receiver receiverNode argumentsNodes blockContext blockValue compiledMethod selectorIsValue |
	
	receiverNode := aRBMessageNode children first.
	receiver := self visit: receiverNode.
	
	argumentsNodes := aRBMessageNode children allButFirst.
	arguments := argumentsNodes collect: [:node | self visit: node].

	"if the node is a tracepoint, the action associated to itself is excecuted after the break"
	self onTracePoint: aRBMessageNode.
	
	"this is looking the method in the current image installed classes. TODO: implement lookup in a better way"
	compiledMethod := receiver systemClass lookupSelector: aRBMessageNode selector.
	"determine if the message is value: or one of its variants"
	selectorIsValue := (201 to: 206) includes: compiledMethod primitive.			
	(receiver class = DASTClosure and: [ selectorIsValue ])
		ifTrue: [  
			blockContext := DASTContext new initializeInContext: self currentContext.
					  arguments doWithIndex: [ :arg :index | 
							blockContext 
								at: (receiver argumentNames at: index)
								put: arg ].
					  currentContext := blockContext.
					  blockValue := self visit: receiver blockNode body.
					  self visit: receiver blockNode.
					  currentContext := blockContext parent.
					  ^ blockValue
					]
		ifFalse: [ 
			^ receiver perform: aRBMessageNode selector withArguments: arguments asArray ]
]

{ #category : #visiting }
DASTInterpreter >> visitReturnNode: aRBReturneNode [
	
	self onTracePoint: aRBReturneNode .
	^ self visit: aRBReturneNode children first
]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	| results |
	results := aRBSequenceNode children collect: [:node | self visit: node ].
	self onTracePoint: aRBSequenceNode.
	^ results last
]

{ #category : #visiting }
DASTInterpreter >> visitVariableNode: aRBVariableNode [
	| varName |

	varName := aRBVariableNode name.
	^ (aRBVariableNode parent isAssignment 
			ifTrue: [ varName ]
			ifFalse: [ self onTracePoint: aRBVariableNode . currentContext find: varName  ])
]
