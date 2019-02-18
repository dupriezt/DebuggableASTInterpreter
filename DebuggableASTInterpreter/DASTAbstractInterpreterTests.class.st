Class {
	#name : #DASTAbstractInterpreterTests,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #running }
DASTAbstractInterpreterTests >> evaluateProgram: aString [
	interpreter initializeWithProgram: (RBParser parseExpression: aString).
	^ interpreter evaluate
]

{ #category : #running }
DASTAbstractInterpreterTests >> setUp [
	interpreter := DASTInterpreter new.
]
