Class {
	#name : #DASTInterpreterSyntaxTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #'tests-incorrect-syntax' }
DASTInterpreterSyntaxTests >> testBlockVarsLocalAccessUndeclaredVariable [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[ x := 1 ] value').
	interpreter signalExceptions: false.
	interpreter evaluate.
	self assert: interpreter exceptions isNotEmpty
	
]

{ #category : #'tests-incorrect-syntax' }
DASTInterpreterSyntaxTests >> testBlockVarsLocalDeclaredInsideBlock [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[|x| x:=1 ] value . x') .
	"exception variable x not found!"
	interpreter signalExceptions: false.
	value := interpreter evaluate.
	
	self assert: interpreter exceptions isNotEmpty .
]

{ #category : #'tests-methods-local-vars' }
DASTInterpreterSyntaxTests >> testLocalVariableAccessUndeclaredVariable [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x').
	interpreter signalExceptions: false. 
	value := interpreter evaluate.
	self assert: interpreter exceptions isEmpty not.
	"self assert: interpreter exceptions last asString equals: 'ZeroDivide'."
]
