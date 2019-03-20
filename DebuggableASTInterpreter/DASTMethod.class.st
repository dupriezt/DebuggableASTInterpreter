Class {
	#name : #DASTMethod,
	#superclass : #DASTClosure,
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTMethod >> initializeWith: aRBNode outerContext: aDASTContext [
	self assert: aRBNode isBlock not.
	super initializeWith:  aRBNode outerContext: aDASTContext 
]

{ #category : #accessing }
DASTMethod >> isBlock [ 
	^ false
]

{ #category : #testing }
DASTMethod >> isMessageValue [
	^ self isPrimitive 
		and: [ (201 to: 206) includes: self primitive ]
]

{ #category : #accessing }
DASTMethod >> isPrimitive [ 
	^ nodeAST isPrimitive
]

{ #category : #accessing }
DASTMethod >> methodClass [
	^ nodeAST methodClass
]

{ #category : #accessing }
DASTMethod >> primitive [ 
	^ nodeAST primitive
]

{ #category : #accessing }
DASTMethod >> selector [
	^ nodeAST selector
]
