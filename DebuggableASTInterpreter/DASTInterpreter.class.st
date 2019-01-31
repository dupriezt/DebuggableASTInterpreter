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
		'exceptions'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #contexts }
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
	process := [value := [[self visit: currentNode] 
									on: Error
									do: [ :e | self exceptions add: e . Transcript show: e asString; cr . semaphore signal]]
					ensure: [semaphore signal]] fork.
	semaphore wait.
	^ value
]

{ #category : #exceptios }
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

{ #category : #execution }
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

{ #category : #execution }
DASTInterpreter >> run [
	
	process 
		ifNil: [ self evaluate "this message will initialize the process that evaluates the tree"]
		ifNotNil: [ semaphore signal. semaphore wait.  ].
	
]

{ #category : #'control-flow' }
DASTInterpreter >> semaphore [
	"used for coordinating the Process process with the main process"
	^semaphore
]

{ #category : #evaluation }
DASTInterpreter >> stackTop [
	^stackTop
]

{ #category : #evaluation }
DASTInterpreter >> visit: aRBNode [
	| value previousNode |
	previousNode := currentNode.
	currentNode := aRBNode.
	"Transcript cr;cr;show: 'visiting';space; show:(aRBNode asString);cr ."
	value := aRBNode acceptVisitor: self.
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
	self currentContext at: name put: value.
	^ value
	
]

{ #category : #visiting }
DASTInterpreter >> visitBlockNode: aRBBlockNode [ 
	"A new context must be created, and its parent must be the current context"
	
	| blockContext |
	blockContext := DASTContext new initializeInContext: currentContext.
	currentContext := blockContext 
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 
	"self onTracePoint: aRBLiteralValueNode."
	^ aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	| arguments receiver receiverNode argumentsNodes |
	
	receiverNode := aRBMessageNode children first.
	receiver := self visit: receiverNode.
	
	argumentsNodes := aRBMessageNode children allButFirst.
	arguments := argumentsNodes collect: [:node | self visit: node].
	"the next call if for controlling the execution of the interpreter 
	depending on the debuggerService mode"
	self onTracePoint: aRBMessageNode .
	
	^ receiver perform: aRBMessageNode selector withArguments: arguments asArray
]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	| results |
	results := aRBSequenceNode children collect: [:node | self visit: node ].
	"self onTracePoint: aRBSequenceNode."
	^ results last
]

{ #category : #visiting }
DASTInterpreter >> visitVariableNode: aRBVariableNode [
	| varName |
	"self onTracePoint: aRBVariableNode ."
	varName := aRBVariableNode name.
	^ (aRBVariableNode parent isAssignment 
			ifTrue: [ varName ]
			ifFalse: [ currentContext find: varName  ])
]
