Class {
	#name : #DASTContextRootSmalltalk,
	#superclass : #DASTContext,
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTContextRootSmalltalk >> find: aByteSymbol [

	^ Smalltalk globals at: aByteSymbol ifAbsent: [ 
		self error: 'Variable ', aByteSymbol , ' not defined!'
		 ]
]

{ #category : #accessing }
DASTContextRootSmalltalk >> isRoot [ 
	^true
]
