Class {
	#name : #DASTBlock,
	#superclass : #DASTClosure,
	#category : #DebuggableASTInterpreter
}

{ #category : #'accessing method dictionary' }
DASTBlock class >> lookupSelector: selector [
	" Hack for accessing method definition of BlockClosure while not inheriting from it"
	| method |
	method := super lookupSelector: selector.
	method ifNotNil: [ ^ method ].
	
	^ BlockClosure lookupSelector: selector
	
	
]

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
DASTBlock >> methodClass [
	^ nodeAST methodNode methodClass
]

{ #category : #accessing }
DASTBlock >> primitive [ 
	"A block always has code inside, and cannot have a primitive declaration "
	^ 0
]

{ #category : #accessing }
DASTBlock >> selector [
	 
	^ 'value' "nodeAST sourceCode"
]

{ #category : #accessing }
DASTBlock >> value: anArg [
	| block |
	block := Smalltalk compiler
		source: self sourceCode;
		context: self outerContext;
		receiver: self outerContext receiver;
		evaluate.
	^ block value: anArg
]
