Class {
	#name : #DASTContextTests,
	#superclass : #TestCase,
	#instVars : [
		'context'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTContextTests >> testContextInitialization [
	context := DASTInterpreter new.
]
