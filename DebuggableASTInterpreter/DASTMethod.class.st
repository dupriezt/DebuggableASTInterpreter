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

{ #category : #accessing }
DASTMethod >> isPrimitive [ 
	^ nodeAST isPrimitive
]

{ #category : #accessing }
DASTMethod >> primitive [ 
	^ nodeAST primitive
]

{ #category : #accessing }
DASTMethod >> selector [
	self shouldBeImplemented 
]

{ #category : #accessing }
DASTMethod >> systemClass [ 
	^ CompiledMethod
]
