Class {
	#name : #DASTStack,
	#superclass : #OrderedCollection,
	#category : #DebuggableASTInterpreter
}

{ #category : #adding }
DASTStack >> pop [
	^ self removeLast 
]

{ #category : #adding }
DASTStack >> push: anObject [
	^ self addLast: anObject 
]

{ #category : #adding }
DASTStack >> top [
	^ self last 
]
