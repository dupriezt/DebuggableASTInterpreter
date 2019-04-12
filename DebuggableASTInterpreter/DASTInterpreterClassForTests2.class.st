Class {
	#name : #DASTInterpreterClassForTests2,
	#superclass : #Object,
	#instVars : [
		'x'
	],
	#category : #'DebuggableASTInterpreter-Tests'
}

{ #category : #initialization }
DASTInterpreterClassForTests2 >> evaluateBlock: aBlock [
	^aBlock value
]

{ #category : #initialization }
DASTInterpreterClassForTests2 >> initialize [ 
	super initialize.
	x := 69
]
