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
