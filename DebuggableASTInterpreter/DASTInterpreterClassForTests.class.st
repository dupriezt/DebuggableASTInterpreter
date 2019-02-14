Class {
	#name : #DASTInterpreterClassForTests,
	#superclass : #Object,
	#category : #DebuggableASTInterpreter
}

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> evaluateBlock: aBlock [
	|t| 
	t := nil.
	^ aBlock value.
]

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

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> getBlockThatReturns32 [
	^ [ ^ 32 ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> getBlockThatReturns32EvaluatedInThisContext [
	^ [ ^ 32 ] value
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> methodEmpty [
	
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> setVariableAndDefineBlock2 [
	| t |
	t := 42.
	^ self evaluateBlock: [ t := 33 . t ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests class >> setVariableAndDefineBlock3 [
	| t |
	t := 42.
	^{ self evaluateBlock: [ t := 33 . t ] .
		self evaluateBlock: [ t ] .
		self evaluateBlock: [ t := 66 . t ] .
		self evaluateBlock: [ t ] } 
]
