Class {
	#name : #DASTContextRootSmalltalk,
	#superclass : #DASTContext,
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTContextRootSmalltalk >> find: aByteSymbol [

	^ Smalltalk globals at: aByteSymbol ifAbsent: [ 
		nil
		"Exception signal: 'Variable ', aByteSymbol , ' not defined!'"
		 ]
]
