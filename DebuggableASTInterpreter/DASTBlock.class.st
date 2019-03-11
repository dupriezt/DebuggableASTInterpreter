Class {
	#name : #DASTBlock,
	#superclass : #DASTClosure,
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTBlock >> initializeWith: aRBNode outerContext: aDASTContext [
	self assert: aRBNode isBlock.
	(aRBNode body statements isEmpty) ifTrue: [ aRBNode body addNode: (RBLiteralValueNode value: nil) ].
	super initializeWith:  aRBNode outerContext: aDASTContext 
]

{ #category : #accessing }
DASTBlock >> isBlock [ 
	^true
]

{ #category : #accessing }
DASTBlock >> isMessageValue [
	^ false
]

{ #category : #accessing }
DASTBlock >> isPrimitive [ 
	"A block always has code inside, and cannot have a primitive declaration "
	^ false
]

{ #category : #accessing }
DASTBlock >> primitive [ 
	"A block always has code inside, and cannot have a primitive declaration "
	self shouldNotImplement 
]

{ #category : #accessing }
DASTBlock >> selector [
	 
	^ 'value' "nodeAST sourceCode"
]

{ #category : #accessing }
DASTBlock >> systemClass [ 
	^ BlockClosure
]
