"
I am a context created to evaluate the body of a method
"
Class {
	#name : #DASTMethodContext,
	#superclass : #DASTContext,
	#category : #DebuggableASTInterpreter
}

{ #category : #initialization }
DASTMethodContext >> initializeContext [

	| compiledMethod theMethod visitor aClass aSelector |
	
	self	parent: sender.
	aSelector := messageNode selector.
	
	aClass := (self receiver isNil and: [ aSelector = #value ]) 
		ifTrue: [ BlockClosure ]
		ifFalse: [ 
			(self receiver isKindOf: DASTBlock) 
				ifTrue: [ BlockClosure ]
				ifFalse: [ self getClassForLookup ]].
	
	compiledMethod := self lookupSelector: aSelector startInClass: aClass.

	theMethod := DASTMethod new initializeWith: compiledMethod ast outerContext: sender.
	
	visitor := DASTPostOrderTreeVisitor new.
	(theMethod doSemanticAnalysis body) acceptVisitor: visitor.
	nodes := visitor stack.
	
	self 	methodOrBlock: theMethod;
			nodes: nodes.
	
]

{ #category : #initialization }
DASTMethodContext >> isBlockContext [ 
	^ false
]
