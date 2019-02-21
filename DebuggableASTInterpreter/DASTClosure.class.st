"
I represent a blockClosure, I am partially polymorphic with BlockClosure
"
Class {
	#name : #DASTClosure,
	#superclass : #Object,
	#instVars : [
		'outerContext',
		'sourceCode',
		'nodeAST',
		'numArgs'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTClosure >> argumentCount [
	^numArgs 
]

{ #category : #accessing }
DASTClosure >> argumentNames [
	^ (nodeAST arguments collect: [:arg | arg name]) asArray.
]

{ #category : #accessing }
DASTClosure >> asText [
	^ self sourceCode asText
]

{ #category : #accessing }
DASTClosure >> body [
	
	^ nodeAST body
]

{ #category : #testing }
DASTClosure >> doSemanticAnalysis [

	^ nodeAST 
]

{ #category : #initialization }
DASTClosure >> initializeWith: aRBNode outerContext: aDASTContext [
	
	sourceCode := aRBNode sourceCode.
	outerContext := aDASTContext.
	nodeAST := aRBNode.
	numArgs := nodeAST arguments size
	
]

{ #category : #accessing }
DASTClosure >> isBlock [ 
	self subclassResponsibility 
]

{ #category : #testing }
DASTClosure >> isPrimitive [
	self subclassResponsibility 
]

{ #category : #accessing }
DASTClosure >> nodeAST [
	^ nodeAST
]

{ #category : #accessing }
DASTClosure >> outerContext [
	^ outerContext isBlockContext 
		ifTrue: [ outerContext methodOrBlock outerContext ]
		ifFalse: [ outerContext ]
]

{ #category : #accessing }
DASTClosure >> primitive [
	self subclassResponsibility 
]

{ #category : #accessing }
DASTClosure >> selector [
	self subclassResponsibility 
]

{ #category : #accessing }
DASTClosure >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
DASTClosure >> systemClass [
	self subclassResponsibility 
]
