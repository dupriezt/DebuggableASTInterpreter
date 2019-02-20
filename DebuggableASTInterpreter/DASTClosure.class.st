"
I represent a blockClosure, I am partially polymorphic with BlockClosure
"
Class {
	#name : #DASTClosure,
	#superclass : #Object,
	#instVars : [
		'outerContext',
		'blockNode',
		'sourceCode',
		'numArgs'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTClosure >> argumentCount [
	^numArgs .
]

{ #category : #accessing }
DASTClosure >> argumentNames [
	^ (blockNode arguments collect: [:arg | arg name]) asArray.
]

{ #category : #accessing }
DASTClosure >> asText [
	^ self sourceCode asText
]

{ #category : #accessing }
DASTClosure >> block [
	self shouldBeImplemented 
]

{ #category : #accessing }
DASTClosure >> blockNode [
	^ blockNode
]

{ #category : #accessing }
DASTClosure >> body [
	
	^ blockNode body
]

{ #category : #testing }
DASTClosure >> doSemanticAnalysis [

	^ blockNode 
]

{ #category : #initialization }
DASTClosure >> initializeWith: aRBBlockNode outerContext: aDASTContext [
	self assert: aRBBlockNode isBlock.
	sourceCode := aRBBlockNode sourceCode.
	outerContext := aDASTContext.
	blockNode := aRBBlockNode.
	numArgs := blockNode arguments size
]

{ #category : #accessing }
DASTClosure >> isBlock [ 
	^ true
]

{ #category : #accessing }
DASTClosure >> isDASTClosure [ 
	^true
]

{ #category : #testing }
DASTClosure >> isPrimitive [
	" A closure always has code inside, and cannot have a primitive declaration "
	^ false
]

{ #category : #accessing }
DASTClosure >> outerContext [
	^ outerContext isBlockContext 
		ifTrue: [ outerContext method outerContext ]
		ifFalse: [ outerContext ]
]

{ #category : #accessing }
DASTClosure >> selector [
	^ blockNode sourceCode
]

{ #category : #accessing }
DASTClosure >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
DASTClosure >> systemClass [
	^ BlockClosure
]
