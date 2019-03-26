"
I am a context created to evaluate the body of a block
"
Class {
	#name : #DASTBlockValueContext,
	#superclass : #DASTContext,
	#category : #DebuggableASTInterpreter
}

{ #category : #initialization }
DASTBlockValueContext >> contextTag [
	^ closure outerContext
]

{ #category : #initialization }
DASTBlockValueContext >> initializeContext [
	
	| visitor |
	" My receiver is the DASTBlock that received the message value (or any of its variants)"
	self	parent: receiver outerContext.
	"
	aClass := (self receiver isNil and: [ aSelector = #value ]) 
		ifTrue: [ BlockClosure ]
		ifFalse: [ self getClassForLookup ].
	"
	visitor := DASTPostOrderTreeVisitor new.
	(receiver doSemanticAnalysis body) acceptVisitor: visitor.
	nodes := visitor stack.
	
	self 	methodOrBlock: receiver;
			nodes: nodes.
	
]

{ #category : #initialization }
DASTBlockValueContext >> isBlockContext [
	^ true
]

{ #category : #initialization }
DASTBlockValueContext >> isUnwindContext [
	"is this context for  method that is marked?"
	^ false
]

{ #category : #initialization }
DASTBlockValueContext >> printOn: aStream [
	aStream nextPutAll: closure printString , ' in '.
			closure outerContext printOn: aStream
]

{ #category : #initialization }
DASTBlockValueContext >> receiver [
	^ closure outerContext receiver
]
