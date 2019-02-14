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
		'signalExceptions',
		'hasReturned'
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
	self setInitialContext.
	^ self visit: currentNode.
]

{ #category : #accessors }
DASTInterpreter >> exceptions [
	^ exceptions ifNil: [ exceptions := OrderedCollection new ]
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [
	currentNode := aRBNode.
	hasReturned := false.
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

{ #category : #private }
DASTInterpreter >> setInitialContext [
	"ugly method necessary because we are putting the root expression of the AST inside a block and sending it the message value"
	currentContext := DASTContext new
		parent: DASTContextRootSmalltalk new;
		method: currentNode methodNode;
		yourself
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
		
		^ self visit: closure blockNode body.
		 ].

	"primitives applied to blocks:"
	(anObject isKindOf: DASTClosure) ifTrue: [ 
		anInteger = 266 ifTrue: [ ^ anObject argumentCount ].
		self error: 'Fallo primitiva sobre closure ', anInteger asString.
		 ].
	 
	
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
DASTInterpreter >> visitArgumentNode: aRBArgumentNode [ 
	
	^ self visitVariableNode: aRBArgumentNode
]

{ #category : #visiting }
DASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	| name value |
	self assert: (aRBAssignmentNode children size = 2).
	name := aRBAssignmentNode variable name.
	value := self visit: aRBAssignmentNode value.
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
	self onTracePoint: aRBBlockNode.
	"if the node is a tracepoint, the action associated to itself is excecuted after the break"
	^ DASTClosure new initializeWith: aRBBlockNode outerContext: currentContext.
	
]

{ #category : #visiting }
DASTInterpreter >> visitInstanceVariableNode: aRBInstanceVariableNode [ 
	
	^ self currentContext findInstVarNamed: aRBInstanceVariableNode name
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 
	self onTracePoint: aRBLiteralValueNode.
	^ aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	| arguments receiver compiledMethod methodArgsNames methodValue methodContext previousContext result selector receiverClass method parent |

	" Resolve Arguments "
	receiver := self visit: aRBMessageNode receiver.
	arguments := aRBMessageNode arguments collect: [:node | self visit: node].
	selector := aRBMessageNode selector.
	
	" Lookup "
	receiverClass := (receiver isNil and: [ selector = #value ]) 
		ifTrue: [ BlockClosure ] "ugly hack to handle the first block value with nil as receiver"
		ifFalse: [ receiver systemClass ].
		
	compiledMethod := receiverClass lookupSelector: selector.
	
	self onTracePoint: aRBMessageNode.
	method := ((receiver isKindOf: DASTClosure) and: [ compiledMethod isKindOfValue ])
		ifTrue: [ receiver ]
		ifFalse: [ compiledMethod ast ].
	parent := ((receiver isKindOf: DASTClosure) and: [ compiledMethod isKindOfValue ])
		ifTrue: [ receiver outerContext ]
		ifFalse: [ self currentContext ].

	methodContext := DASTContext new
		parent: parent;
		receiver: receiver;
		method: method;
		yourself.
	
	" Apply - invoke method "
	previousContext := currentContext.
	currentContext := methodContext.
	method isPrimitive ifTrue: [ 
		
		result := self solvePrimitive: compiledMethod primitive receiver: receiver arguments: arguments. 
		currentContext := previousContext.
		^ result
		].

	methodArgsNames := method argumentNames.
	arguments doWithIndex: 
				[ :arg :index | 
					currentContext 
						at: (methodArgsNames at: index)
						put: arg ].
				
	methodValue := self visit: methodContext method body.
	
	currentContext := previousContext.
	
	^ methodValue 
			
]

{ #category : #visiting }
DASTInterpreter >> visitMethodNode: aRBBlockNode [ 
	
	self onTracePoint: aRBBlockNode.
	
	
]

{ #category : #visiting }
DASTInterpreter >> visitReturnNode: aRBReturneNode [
	
	| result |
	self onTracePoint: aRBReturneNode .
	result := self visit: aRBReturneNode value.
	hasReturned := true.
	^ result
]

{ #category : #visiting }
DASTInterpreter >> visitSelfNode: aRBSelfNode [ 
	
	^ self currentContext receiver

]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	| lastResult |
	aRBSequenceNode children collect: [:node | 
		lastResult := self visit: node.
		hasReturned ifTrue: [ hasReturned := false. ^ lastResult ]. 
	].
	self onTracePoint: aRBSequenceNode.
	
	^ self currentContext isBlockContext
		ifTrue: [ lastResult ]
		ifFalse: [ self currentContext receiver ]
]

{ #category : #visiting }
DASTInterpreter >> visitSuperNode: aRBSuperNode [ 
	^ self currentContext receiver superclass
]

{ #category : #visiting }
DASTInterpreter >> visitTemporaryNode: aRBTemporaryNode [
	^ currentContext find: aRBTemporaryNode name 
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
