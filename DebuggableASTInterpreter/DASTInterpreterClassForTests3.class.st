Class {
	#name : #DASTInterpreterClassForTests3,
	#superclass : #Object,
	#instVars : [
		'x'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #initialization }
DASTInterpreterClassForTests3 >> evaluateBlock [
	^self evaluateBlock: [ x ]
]

{ #category : #initialization }
DASTInterpreterClassForTests3 >> evaluateBlock: aBlock [
	^DASTInterpreterClassForTests2 new evaluateBlock: aBlock
]

{ #category : #initialization }
DASTInterpreterClassForTests3 >> initialize [
	super initialize.
	x := 123
]
