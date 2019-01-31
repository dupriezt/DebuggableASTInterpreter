"
I represent a blockClosure, I am partially polymorphic with BlockClosure
"
Class {
	#name : #DASTClosure,
	#superclass : #Object,
	#instVars : [
		'outerContext',
		'blockNode',
		'sourceCode'
	],
	#category : #DebuggableASTInterpreter
}

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

{ #category : #initialization }
DASTClosure >> initializeWith: aRBBlockNode outerContext: aDASTContext [
	self assert: aRBBlockNode isBlock.
	sourceCode := aRBBlockNode sourceCode.
	outerContext := aDASTContext.
	blockNode := aRBBlockNode.
]

{ #category : #accessing }
DASTClosure >> outerContext [
	^ outerContext
]

{ #category : #accessing }
DASTClosure >> sourceCode [
	^ sourceCode
]
