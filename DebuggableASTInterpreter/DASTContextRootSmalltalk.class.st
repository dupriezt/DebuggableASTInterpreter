"
I'm the first context, the one who accesses global variables. 
I must be refactored when contexts start to use DASTEnvironments
"
Class {
	#name : #DASTContextRootSmalltalk,
	#superclass : #DASTContext,
	#category : #'DebuggableASTInterpreter-Contexts'
}

{ #category : #accessing }
DASTContextRootSmalltalk >> findVariable: aByteSymbol [

	^ (self evaluator environment bindingOf: aByteSymbol) 
		ifNil: [ self error: 'Variable ', aByteSymbol , ' not defined!' ] 
		ifNotNil: [  :b | b value ]
]

{ #category : #accessing }
DASTContextRootSmalltalk >> isBlockContext [
	^false
]

{ #category : #accessing }
DASTContextRootSmalltalk >> isRoot [ 
	^true
]

{ #category : #accessing }
DASTContextRootSmalltalk >> isUnwindContext [
	"is this context for  method that is marked?"
	^ self shouldNotImplement 
]

{ #category : #'as yet unclassified' }
DASTContextRootSmalltalk >> temps: aCollection [ 
	self shouldBeImplemented.
]
