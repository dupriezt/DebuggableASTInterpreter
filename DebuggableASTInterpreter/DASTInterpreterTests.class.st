Class {
	#name : #DASTInterpreterTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTInterpreterTests >> testAddTwoNumbersPopsArgumentsFromStack [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').

	interpreter step.
	interpreter step.
	interpreter step.

	interpreter pop.

	self assert: interpreter stack isEmpty
]

{ #category : #tests }
DASTInterpreterTests >> testAddTwoNumbersPushesResultInStack [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').

	interpreter step.
	interpreter step.
	interpreter step.

	self assert: interpreter pop equals: 3
]

{ #category : #tests }
DASTInterpreterTests >> testAssignAndEvaluateTemporaryVariable [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x := 1 . x + 2').
	
	
	self assert: interpreter evaluate equals: 3
]

{ #category : #tests }
DASTInterpreterTests >> testAssignmentTemporaryVariable [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x := 1').
	
	
	self assert: interpreter evaluate equals: 1
]

{ #category : #tests }
DASTInterpreterTests >> testBinaryMessageSendPushesReceiverAndArguments [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').
	
	interpreter step.
	interpreter step.

	self assert: interpreter pop equals: 2.
	self assert: interpreter pop equals: 1.
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateConstant [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1').
	
	interpreter step.
	self assert: interpreter stackTop equals: 1
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateFullExpression [
	| interpreter |
	"evaluates the whole expression"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1 - 3 abs').
	self assert: interpreter evaluate equals: -2.
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateFullUnaryExpression [
	| interpreter |
	"evaluates the whole expression"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1').
	self assert: interpreter evaluate equals: 1.
]

{ #category : #tests }
DASTInterpreterTests >> testParenthesisForOperationAndUnaryMessage [

	| interpreter |
	"The unary message must be evaluated before the Add"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '(1 - 3) abs').
	interpreter step.
	interpreter step.
	interpreter step.
	interpreter step.
	self assert: interpreter pop equals: 2.
]

{ #category : #tests }
DASTInterpreterTests >> testPrecedenceForOperationAndMessageWithArgument [

	| interpreter |
	"The unary message must be evaluated before the Add"
	interpreter := DASTInterpreter new.

	interpreter initializeWithProgram: (RBParser parseExpression: '#abc at: 3 - 1').
	interpreter step.
	interpreter step.
	interpreter step.
	interpreter step.
	interpreter step.
	self assert: interpreter pop equals: $b.
]

{ #category : #tests }
DASTInterpreterTests >> testPrecedenceForOperationAndUnaryMessage [

	| interpreter |
	"The unary message must be evaluated before the Add"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1 - 3 abs').
	interpreter step.
	interpreter step.
	interpreter step.
	interpreter step.
	self assert: interpreter pop equals: -2.
]
