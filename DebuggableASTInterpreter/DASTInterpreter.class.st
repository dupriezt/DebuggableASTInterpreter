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

{ #category : #'as yet unclassified' }
DASTInterpreter >> context [
	self shouldBeImplemented.
]

{ #category : #accessors }
DASTInterpreter >> currentContext [
	^ currentContext.
]

{ #category : #execution }
DASTInterpreter >> currentNode [
	^ currentNode
]

{ #category : #accessors }
DASTInterpreter >> debuggerService: aDASTDebuggerService [
	debuggerService := aDASTDebuggerService 
]

{ #category : #evaluation }
DASTInterpreter >> evaluate [
	| value |
	semaphore := Semaphore new: 0.
	
	currentContext := DASTContext new parent: DASTContextRootSmalltalk new.
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
		
	currentNode := aRBNode 
]

{ #category : #'control-flow' }
DASTInterpreter >> onTracePoint: aRBNode [
	debuggerService ifNil: [ ^ self "if the debugger service is not set, the interpreter never steps." ].
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

{ #category : #private }
DASTInterpreter >> solvePrimitive: anInteger receiver: anObject arguments: anArray [
	| primitiveResult blockContext blockValue prevContext closure blockLocalVars |
	
	((201 to: 206) includes: anInteger) ifTrue: [ 
		"primitive is 'value', the receiver is a DASTClosure object"
		closure := anObject.
		blockContext := DASTContext new parent: self currentContext; receiver: closure outerContext receiver.
		blockLocalVars := closure blockNode allDefinedVariables.
		blockLocalVars do: [ :arg |
				blockContext
					at: arg
					put: nil
			 ] .
		anArray doWithIndex: 
		  [ :arg :index | 
				blockContext 
					at: (closure argumentNames at: index)
					 putInHierarchy: arg ].
		
		prevContext := currentContext.
		currentContext := blockContext.
		blockValue := self visit: closure blockNode body.
		currentContext := prevContext.
		^ blockValue
		 ].
	"primitives applied to blocks:"
	anInteger = 266 ifTrue: [ ^ anObject argumentCount ]. 
	
	"apply primitive to object"
	primitiveResult := anObject tryPrimitive: anInteger withArgs: anArray asArray.
	((primitiveResult isKindOf: Array ) and: [primitiveResult first = Context primitiveFailToken first ])
		ifTrue: [self error: 'Fallo primitiva ', anInteger asString ].
	^ primitiveResult

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
	^value
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
	| arguments receiver compiledMethod methodBodyNode methodArgsNames methodValue methodContext previousContext methodLocalVars |
	
	receiver := self visit: aRBMessageNode receiver.
	arguments := aRBMessageNode arguments collect: [:node | self visit: node].
	
	self onTracePoint: aRBMessageNode.
	
	methodContext := DASTContext new parent: self currentContext; receiver: receiver.
	previousContext := currentContext.
	currentContext := methodContext.
	compiledMethod := self currentContext lookupSelector: aRBMessageNode selector.
	compiledMethod isPrimitive ifTrue: [ ^ self solvePrimitive: compiledMethod primitive receiver: receiver arguments: arguments. ].
	methodBodyNode := (RBParser parseCompiledMethod: compiledMethod) addSelfReturn; parent: aRBMessageNode.
	methodArgsNames := methodBodyNode arguments collect: [:node | self visit: node ].
	methodLocalVars := methodBodyNode allDefinedVariables.
	methodLocalVars do: [ :arg |
		currentContext
			at: arg
			put: nil
	] .
	arguments doWithIndex: 
				[ :arg :index | 
					currentContext 
						at: (methodArgsNames at: index)
						put: arg ].
				
	methodValue := self visit: methodBodyNode body.
	
	currentContext := previousContext.
	
	^ methodValue 
			
]

{ #category : #visiting }
DASTInterpreter >> visitMethodNode: aRBBlockNode [ 
	
	self onTracePoint: aRBBlockNode.
	
	
]

{ #category : #visiting }
DASTInterpreter >> visitReturnNode: aRBReturneNode [
	
	self onTracePoint: aRBReturneNode .
	^ self visit: aRBReturneNode children first
]

{ #category : #visiting }
DASTInterpreter >> visitSelfNode: aRBSelfNode [ 
	| receiver |
	receiver := self currentContext receiver.
	"ugly check"
	receiver class = DASTClosure ifTrue: [ 
		^self visit: receiver blockNode body
	].
	^ receiver
	
]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	| results |
	results := aRBSequenceNode children collect: [:node | self visit: node ].
	self onTracePoint: aRBSequenceNode.
	^ results last
]

{ #category : #visiting }
DASTInterpreter >> visitSuperNode: aRBSuperNode [ 
	^ self currentContext receiver superclass
]

{ #category : #visiting }
DASTInterpreter >> visitVariableNode: aRBVariableNode [
	| varName |
	varName := aRBVariableNode name.
	(aRBVariableNode isVariableNameInAssignation or: [ aRBVariableNode isArgumentInMethod ])
			ifTrue: [ currentContext find: varName. 
						 ^ varName ] "left side of :=, or the argument in a method"
			ifFalse: [ self onTracePoint: aRBVariableNode . 
						  ^ currentContext find: varName  ] "right side of :="
]
