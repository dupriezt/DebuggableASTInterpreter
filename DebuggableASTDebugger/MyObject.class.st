"
Test object for documentation experiments.
"
Class {
	#name : #MyObject,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #DebuggableASTDebugger
}

{ #category : #'as yet unclassified' }
MyObject >> doStuff [
	|var1 var2|
	var1 := Random new next.
	var2 := Random new next.
	self setX: var1 y: var2.
	^x@y
]

{ #category : #'as yet unclassified' }
MyObject >> setX: var1 y: var2 [
	x := var1.
	y := var2
]
