Class {
	#name : #DASTInterpreterClassForTests,
	#superclass : #Object,
	#category : #DebuggableASTInterpreter
}

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> getBlockThatAccessesVariableTSetAs42 [
	| t |
	t := 42.
	^ [ t ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> getBlockThatEvaluatesConstant42 [
	^ [ 42 ]
]
