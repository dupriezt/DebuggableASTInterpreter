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
	self initializeProgram: aString.
	^ interpreter evaluate
]

{ #category : #running }
DASTAbstractInterpreterTests >> initializeProgram: aString [
	interpreter initializeWithProgram: (RBParser parseExpression: aString).
]

{ #category : #running }
DASTAbstractInterpreterTests >> setUp [
	interpreter := DASTInterpreter new.
]
