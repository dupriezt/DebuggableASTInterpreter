Class {
	#name : #DASTContextRootSmalltalk,
	#superclass : #DASTContext,
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTContextRootSmalltalk >> find: aByteSymbol [

	^ Smalltalk at: aByteSymbol ifAbsent: [ 
		nil
		"Exception signal: 'Variable ', aByteSymbol , ' not defined!'"
		 ]
]
