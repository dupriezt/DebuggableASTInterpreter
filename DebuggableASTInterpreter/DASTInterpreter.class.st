"
I can interpret a program represented as an AST tree
"
Class {
	#name : #DASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'currentContext',
		'debuggerService',
		'exceptions',
		'signalExceptions',
		'suspended'
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
	^ currentContext nodes top
]

{ #category : #accessors }
DASTInterpreter >> debuggerService: aDASTDebuggerService [
	debuggerService := aDASTDebuggerService 
]

{ #category : #evaluation }
DASTInterpreter >> evaluate [
	[ currentContext nodes isEmpty ] whileFalse: [  
		self visit: currentContext nodes pop .
		 ].
	^ self stackTop
]

{ #category : #accessors }
DASTInterpreter >> exceptions [
	^ exceptions ifNil: [ exceptions := OrderedCollection new ]
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [
	| visitor nodes rootContext |
	visitor := DASTPostOrderTreeVisitor new.
	
	(aRBNode doSemanticAnalysis body addReturn; yourself) acceptVisitor: visitor.
	nodes := visitor stack.
	rootContext := DASTContextRootSmalltalk new. 
	"ugly method necessary because we are putting the root expression of the AST inside a return and sending it the message value"
	currentContext := DASTContext new
		parent: rootContext;
		method: nodes last methodNode;
		nodes: nodes;
		senderContext: rootContext;
		yourself
	
]

{ #category : #testing }
DASTInterpreter >> isTerminated [
	^ self currentContext hasReturned.
]

{ #category : #'control-flow' }
DASTInterpreter >> onTracePoint: aRBNode [
	debuggerService ifNil: [ ^ false  ]. "if the debugger service is not set, the interpreter never steps."
	^ debuggerService onTracePoint: aRBNode. "returns true if the node is a trace point, and therefore the interpreter must step here"

	
]

{ #category : #'control-flow' }
DASTInterpreter >> resumeProcess [
	suspended := false
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
	| primitiveResult closure |
	
	((201 to: 206) includes: anInteger) ifTrue: [ 
		"primitive is 'value', the receiver is a DASTClosure object"
		closure := anObject.
		
		anArray doWithIndex: 
		  [ :arg :index | 
				currentContext 
					at: (closure argumentNames at: index)
					 put: arg ].
		
		^self
		 ].
	"the primitive call doesn't require a context for now"
	currentContext := currentContext senderContext.
		 
	"primitives applied to blocks:"
	(anObject isKindOf: DASTClosure) ifTrue: [ 
		anInteger = 266 ifTrue: [ 
			^self stackPush: anObject argumentCount. 
		 ].
		self error: 'Fallo primitiva sobre closure ', anInteger asString.
		 ].
	 
	
	"apply primitive to object"
	primitiveResult := anObject tryPrimitive: anInteger withArgs: anArray asArray.
	((primitiveResult isKindOf: Array ) and: [primitiveResult first = Context primitiveFailToken first ])
		ifTrue: [self error: 'Fallo primitiva ', anInteger asString ].
	^ self stackPush: primitiveResult

]

{ #category : #visiting }
DASTInterpreter >> stackPop [
	^ currentContext stack pop
]

{ #category : #visiting }
DASTInterpreter >> stackPush: anObject [ 
	currentContext stack push: anObject
]

{ #category : #visiting }
DASTInterpreter >> stackTop [
	^ currentContext stack top
]

{ #category : #evaluation }
DASTInterpreter >> visit: aRBNode [
	"Transcript cr;cr;show: 'visiting';space; show:(aRBNode asString);cr .
	Transcript show: currentContext stack asString;cr.
	Transcript show: currentContext nodes asString;cr."
	aRBNode acceptVisitor: self.
	"Transcript show: currentContext stack asString;cr.
	Transcript show: currentContext nodes asString;cr.
	"
]

{ #category : #visiting }
DASTInterpreter >> visitArgumentNode: aRBArgumentNode [ 
	^self stackPush: (currentContext find: aRBArgumentNode name)
]

{ #category : #visiting }
DASTInterpreter >> visitArrayNode: aRBArrayNode [ 
	^ (aRBArrayNode statements collect: [:statement | self visit: statement]) asArray
]

{ #category : #visiting }
DASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	| name value |
	name := aRBAssignmentNode variable name.
	value := self stackTop.
	self onTracePoint: aRBAssignmentNode.
	"if the node is a tracepoint, the action associated to itself is excecuted after the break"
	
	(self currentContext lookupContextDefining: name)
		ifNotNil: [ :definingContext | 
			definingContext at: name put: value.
			^ value ].

	(self currentContext receiver systemClass allInstVarNames includes: name)
		ifTrue: [ self currentContext receiver instVarNamed: name put: value ].

	^value
]

{ #category : #visiting }
DASTInterpreter >> visitBlockNode: aRBBlockNode [ 
	| closure |
	self onTracePoint: aRBBlockNode.
	"if the node is a tracepoint, the action associated to itself is excecuted after the break"
	closure := DASTClosure new initializeWith: aRBBlockNode outerContext: currentContext.
	^self stackPush: closure.
	
	
]

{ #category : #visiting }
DASTInterpreter >> visitGlobalNode: aRBGlobalNode [ 
	^self stackPush: (currentContext find: aRBGlobalNode name)
	
]

{ #category : #visiting }
DASTInterpreter >> visitInstanceVariableNode: aRBInstanceVariableNode [ 
	
	^self stackPush: (self currentContext findInstVarNamed: aRBInstanceVariableNode name)
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 
	self onTracePoint: aRBLiteralValueNode.
	^self stackPush: aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	| arguments receiver compiledMethod methodArgsNames methodContext selector receiverClass method parent valueSentToBlock visitor nodes |
	
	" Resolve Arguments "
	arguments := Array new: aRBMessageNode numArgs.
	(1 to: aRBMessageNode numArgs) do: [:i |
		arguments at: i put: self stackPop ].
	arguments := arguments reverse.
	receiver := self stackPop.
	selector := aRBMessageNode selector.
	
	" Lookup "
	receiverClass := (receiver isNil and: [ selector = #value ]) 
		ifTrue: [ BlockClosure ] "ugly hack to handle the first block value with nil as receiver"
		ifFalse: [ receiver systemClass ].

	compiledMethod := receiverClass lookupSelector: selector.
	
	self onTracePoint: aRBMessageNode.
	
	valueSentToBlock := (receiver isKindOf: DASTClosure) and: [ compiledMethod isKindOfValue ].
	
	method := valueSentToBlock
		ifTrue: [ receiver ]
		ifFalse: [ compiledMethod ast ].
	parent := valueSentToBlock
		ifTrue: [ receiver outerContext ]
		ifFalse: [ self currentContext ].

self flag: 'ToDo: Refactoring!!'.
"please refactor me!"

	visitor := DASTPostOrderTreeVisitor new.
	(method doSemanticAnalysis body) acceptVisitor: visitor.
	nodes := visitor stack.
	

	methodContext := DASTContext new
		parent: parent;
		receiver: receiver;
		method: method;
		nodes: nodes;
		senderContext: currentContext; 
		yourself.
	" Apply - invoke method "
	currentContext := methodContext.
	(method isPrimitive or: [ valueSentToBlock ]) ifTrue: [ 
		
		self solvePrimitive: compiledMethod primitive receiver: receiver arguments: arguments.
		^ self
		].
	methodArgsNames := method argumentNames.
	arguments doWithIndex: 
				[ :arg :index | 
					currentContext 
						at: (methodArgsNames at: index)
						put: arg ].
				
	"self evaluate ."
	
	^ self 
			
]

{ #category : #visiting }
DASTInterpreter >> visitMethodNode: aRBBlockNode [ 
	
	self onTracePoint: aRBBlockNode.
	
	
]

{ #category : #visiting }
DASTInterpreter >> visitReturnNode: aRBReturneNode [
	| value senderContext |
	self onTracePoint: aRBReturneNode.
	self currentContext setAsReturned.
	value := currentContext stack top.
	
	senderContext := 
		self currentContext isBlockContext 
			ifTrue: [ currentContext parent senderContext]
			ifFalse: [ currentContext senderContext ].
	
	currentContext := senderContext.
	self stackPush: value
]

{ #category : #visiting }
DASTInterpreter >> visitSelfNode: aRBSelfNode [ 
	^ self stackPush: self currentContext receiver

]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	"| lastResult |
	aRBSequenceNode children collect: [:node | 
		lastResult := self visit: node.
		self currentContext hasReturned ifTrue: [ ^ lastResult ]. 
	]."
	| lastResult |
	self onTracePoint: aRBSequenceNode.
	lastResult := self currentContext isBlockContext 
		ifTrue: [ self stackPop ]
		ifFalse: [ self currentContext receiver ].
	
	currentContext := currentContext senderContext.
	self stackPush: lastResult. 
	
	"self currentContext isBlockContext
		ifTrue: [ lastResult ]
		ifFalse: [ self currentContext receiver ]"
]

{ #category : #visiting }
DASTInterpreter >> visitSuperNode: aRBSuperNode [ 
	| receiver |
	receiver := self currentContext receiver.
	^ receiver isClass 
	ifTrue: [ self stackPush: receiver superclass  ] 
	ifFalse: [ self stackPush: receiver class superclass ]
]

{ #category : #visiting }
DASTInterpreter >> visitTemporaryNode: aRBTemporaryNode [
	| name |
	name := aRBTemporaryNode name.
	^ (aRBTemporaryNode isDefinition) 
		ifTrue: [ currentContext at: name put: nil ]
		ifFalse: [ self stackPush: (currentContext find: name)]
]

{ #category : #visiting }
DASTInterpreter >> visitVariableNode: aRBVariableNode [
	| varName |
	varName := aRBVariableNode name.
	(aRBVariableNode isDefinition or: [ aRBVariableNode isArgumentInMethod ]) ifTrue: [ currentContext at: varName put: nil. ^ varName ].
	
	(aRBVariableNode isVariableNameInAssignation)
			ifTrue: [ currentContext find: varName. 
						 ^ varName ] "left side of :=, or the argument in a method"
			ifFalse: [ self onTracePoint: aRBVariableNode . 
						  ^ currentContext find: varName  ] "right side of :="
]
