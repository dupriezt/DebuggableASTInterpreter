"
I can interpret a program represented as an AST tree
"
Class {
	#name : #DASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'currentContext'
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

{ #category : #accessors }
DASTInterpreter >> currentNode [
	^ currentContext nodes top
]

{ #category : #evaluation }
DASTInterpreter >> evaluate [
	[ currentContext nodes isEmpty ] whileFalse: [  
		self visit: currentContext nodes pop .
		 ].
	^ self stackTop
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [
	| visitor nodes rootContext |
	visitor := DASTPostOrderTreeVisitor new.
	
	(aRBNode doSemanticAnalysis body addReturn; yourself) acceptVisitor: visitor.
	nodes := visitor stack.
	rootContext := DASTContextRootSmalltalk new. 
	"ugly method necessary because we are putting the root expression of the AST inside a return and sending it the message value"
	self flag: 'update next call'.
	currentContext := DASTContext new
		parentContext: rootContext;
		methodOrBlock: nodes last methodNode;
		nodes: nodes;
		senderContext: rootContext;
		yourself.
	
]

{ #category : #testing }
DASTInterpreter >> isTerminated [
	self flag: 'ToDo: is this method necessary?'.
	^ self currentContext nodes isEmpty and: [self currentContext parentContext isRoot].
]

{ #category : #testing }
DASTInterpreter >> primitiveResultIsError: anObject [
	^ (anObject isKindOf: Array ) and: [anObject first = Context primitiveFailToken first ]
]

{ #category : #private }
DASTInterpreter >> solvePrimitive: anInteger receiver: anObject arguments: anArray [
	| primitiveResult |
	currentContext := currentContext parentContext.
		
	"primitives applied to blocks:"
	(anObject isKindOf: DASTClosure) ifTrue: [ 
		anInteger = 266 ifTrue: [ 
			^self stackPush: anObject argumentCount. 
		 ].
		DASTPrimitiveFailed signalWithPrimitive: anInteger receiver: anObject 
	].
	 	
	"apply primitive to object"
	primitiveResult := anObject tryPrimitive: anInteger withArgs: anArray asArray.
	(self primitiveResultIsError: primitiveResult)
		ifTrue: [DASTPrimitiveFailed signalWithPrimitive: anInteger receiver: anObject ].
	self stackPush: primitiveResult

]

{ #category : #stack }
DASTInterpreter >> stackPop [
	^ currentContext stack pop
]

{ #category : #stack }
DASTInterpreter >> stackPop: anInteger [
	| pops |
	pops := Array new: anInteger.
	(1 to: anInteger) do: [:i |
		pops at: i put: self stackPop ].
	^ pops
]

{ #category : #stack }
DASTInterpreter >> stackPush: anObject [ 
	currentContext stack push: anObject
]

{ #category : #stack }
DASTInterpreter >> stackTop [
	^ currentContext stack
		ifNotNil: [ :s | s ifEmpty: [ nil ]
								 ifNotEmpty: [s top] ] 
		ifNil: [ nil ]
]

{ #category : #evaluation }
DASTInterpreter >> stepInto [
	currentContext nodes isEmpty ifTrue: [ DASTEvaluationTerminated  signal].
	self visit: currentContext nodes pop .
	^ self stackTop
]

{ #category : #evaluation }
DASTInterpreter >> stepOver [
	| initialContext |
	initialContext := currentContext.
	self stepInto.
	[ currentContext ~= initialContext] whileTrue: [ 
		self stepInto.
	 ].

	^ self stackTop
]

{ #category : #visiting }
DASTInterpreter >> visit: aRBNode [

	aRBNode acceptVisitor: self
]

{ #category : #visiting }
DASTInterpreter >> visitArgumentNode: aRBArgumentNode [ 

	self stackPush: (currentContext findVariable: aRBArgumentNode name)
]

{ #category : #visiting }
DASTInterpreter >> visitArrayNode: aRBArrayNode [ 
	| literals size |
	
	size := aRBArrayNode statements size.
	literals := self stackPop: size.
	self stackPush: literals reverse
]

{ #category : #visiting }
DASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	| name value |
	name := aRBAssignmentNode variable name.
	value := self stackTop.
	
	"Temporary variables assignment"
	(self currentContext lookupContextDefiningLocalVariable: name)
		ifNotNil: [ :definingContext | definingContext at: name put: value. ^ self ].
	
	"Instance variables assignment"
	(self currentContext receiver systemClass allInstVarNames includes: name)
		ifTrue: [ self currentContext receiver instVarNamed: name put: value . ^ self].

	"ToDo: fix this step since it's updating the class in the system and not in the environment"
	(self currentContext receiver systemClass classPool includesKey: name)
		ifTrue: [ self currentContext receiver systemClass classPool at: name put: value . ^ self].
		
	Error signal: 'Assignment operation failed for variable "' , name , '" with value "', value asString, '"'
]

{ #category : #visiting }
DASTInterpreter >> visitBlockNode: aRBBlockNode [ 
	
	self stackPush: (DASTBlock new initializeWith: aRBBlockNode outerContext: currentContext)
]

{ #category : #visiting }
DASTInterpreter >> visitCascadeNode: aRBCascadeNode [ 
	| lastResult |
	lastResult := self stackPop.
	currentContext := currentContext senderContext.
	self stackPush: lastResult. 
]

{ #category : #visiting }
DASTInterpreter >> visitGlobalNode: aRBGlobalNode [ 
	self stackPush: (currentContext findVariable: aRBGlobalNode name)
	
]

{ #category : #visiting }
DASTInterpreter >> visitInstanceVariableNode: aRBInstanceVariableNode [ 
	
	self stackPush: (self currentContext findInstanceVariable: aRBInstanceVariableNode name)
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	
	| literals size |
	size := aRBLiteralArrayNode contents size.
	literals := self stackPop: size.
	self stackPush: literals
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 

	self stackPush: aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	| arguments receiver method |
	
	" Resolve Arguments "
	arguments := (self stackPop: aRBMessageNode numArgs) reverse.
	receiver := self stackPop.
	
	"Current context initialization"
	currentContext := 
		DASTContext new 
			initializeWithParent: self currentContext 
			receiver: receiver 
			messageNode: aRBMessageNode.
	
	"Lookup"
	method := currentContext methodOrBlock.
	" Apply - invoke method "
	(method isPrimitive and: [method isMessageValue not ])  
	ifTrue: [ 
		[self solvePrimitive: method primitive receiver: receiver arguments: arguments]
			on: DASTPrimitiveFailed
			do: [:e | e signal].
		]
	ifFalse: [ 
		currentContext setTemporalVariablesNamed: method argumentNames values: arguments.
	 ]
]

{ #category : #visiting }
DASTInterpreter >> visitMethodNode: aRBBlockNode [ 
	
	
	
	
]

{ #category : #visiting }
DASTInterpreter >> visitReturnNode: aRBReturneNode [
	| value senderContext |
	"self currentContext setAsReturned."
	value := currentContext stack top.
	senderContext := 
		self currentContext isBlockContext 
			ifTrue: [ currentContext parentContext senderContext]
			ifFalse: [ currentContext senderContext ].
	
	currentContext := senderContext.
	self stackPush: value
]

{ #category : #visiting }
DASTInterpreter >> visitSelfNode: aRBSelfNode [ 
	self stackPush: self currentContext receiver

]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	
	| lastResult |
	lastResult := self currentContext isBlockContext 
		ifTrue: [ self stackPop ]
		ifFalse: [ self currentContext receiver ].
	
	currentContext := currentContext senderContext.
	self stackPush: lastResult. 
	
]

{ #category : #visiting }
DASTInterpreter >> visitSuperNode: aRBSuperNode [ 
	self stackPush: self currentContext receiver.
]

{ #category : #visiting }
DASTInterpreter >> visitTemporaryNode: aRBTemporaryNode [
	| name |
	name := aRBTemporaryNode name.
	aRBTemporaryNode isDefinition 
		ifTrue: [ currentContext at: name put: nil ]
		ifFalse: [ self stackPush: (currentContext findVariable: name)]
]
