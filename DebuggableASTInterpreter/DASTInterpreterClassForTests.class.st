Class {
	#name : #DASTInterpreterClassForTests,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> evaluateBlock: aBlock [
	|t| 
	t := nil.
	^ aBlock value.
]

{ #category : #tests }
DASTInterpreterClassForTests >> evaluateBlockAndIgnoreArgument: arg [
	^ block value
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> getBlockThatAccessesVariableTSetAs42 [
	| t |
	t := 42.
	^ [ t ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> getBlockThatEvaluatesConstant42 [
	^ [ 42 ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> getBlockThatReturns32 [
	^ [ ^ 32 ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> getBlockThatReturns32EvaluatedInThisContext [
	^ [ ^ 32 ] value
]

{ #category : #tests }
DASTInterpreterClassForTests >> initialize [ 
	|x|
	super initialize.
	x := 123
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> methodEmpty [
	
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> setVariableAndDefineBlock2 [
	| t |
	t := 42.
	^ self evaluateBlock: [ t := 33 . t ]
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> setVariableAndDefineBlock3 [
	| t |
	t := 42.
	^{ self evaluateBlock: [ t := 33 . t ] .
		self evaluateBlock: [ t ] .
		self evaluateBlock: [ t := 66 . t ] .
		self evaluateBlock: [ t ] } 
]

{ #category : #'as yet unclassified' }
DASTInterpreterClassForTests >> setVariableAndDefineBlock4 [
	| t block |
	"variable lookup is done at excecution time"
	t := 42.
	block := [ t ].
	t := 69.
	^ self evaluateBlock: block
]

{ #category : #tests }
DASTInterpreterClassForTests >> testArg: arg [
	block := [ arg ].
	^ self evaluateBlockAndIgnoreArgument: 'zork'
]
