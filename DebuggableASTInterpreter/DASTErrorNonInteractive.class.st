Class {
	#name : #DASTErrorNonInteractive,
	#superclass : #Object,
	#instVars : [
		'messageText',
		'exception'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTErrorNonInteractive >> exception [
	^ exception
]

{ #category : #accessing }
DASTErrorNonInteractive >> exception: anObject [
	exception := anObject
]

{ #category : #signalling }
DASTErrorNonInteractive >> signal [ 
	thisContext unhandledException: self exception.
	
]
