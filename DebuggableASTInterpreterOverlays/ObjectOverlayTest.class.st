Class {
	#name : #ObjectOverlayTest,
	#superclass : #TestCase,
	#instVars : [
		'point',
		'pointOverlay',
		'interpreter'
	],
	#category : #'DebuggableASTInterpreterOverlays-Tests'
}

{ #category : #running }
ObjectOverlayTest >> setUp [
	super setUp.
	point := 4 @ 2.
	pointOverlay := ObjectOverlay on: point
]

{ #category : #tests }
ObjectOverlayTest >> testReadInstanceVariableFetchesLastOverlayValue [
	pointOverlay
		write: 1
		toInstVarNamed: #x
		fromNode: nil
		inContext: DASTContext new
		overlayIndex: nil.
	pointOverlay
		write: 5
		toInstVarNamed: #x
		fromNode: nil
		inContext: DASTContext new
		overlayIndex: nil.
	self
		assert: (pointOverlay readInstanceVariableNamed: #x ifAbsent: [ -1 ])
		equals: 5
]

{ #category : #tests }
ObjectOverlayTest >> testReadInstanceVariableFetchesOriginalValueIfNotOverlayed [
	pointOverlay
		write: 1
		toInstVarNamed: #x
		fromNode: nil
		inContext: DASTContext new
		overlayIndex: nil.
	self
		assert: (pointOverlay readInstanceVariableNamed: #y ifAbsent: [ point y ])
		equals: 2
]

{ #category : #tests }
ObjectOverlayTest >> testWrittenInstanceVariableDoesNotTouchOverlayedObject [
	pointOverlay
		write: 1
		toInstVarNamed: #x
		fromNode: nil
		inContext: DASTContext new
		overlayIndex: nil.
	self assert: point x equals: 4
]

{ #category : #tests }
ObjectOverlayTest >> testWrittenInstanceVariableIsOverlayed [
	pointOverlay
		write: 1
		toInstVarNamed: #x
		fromNode: nil
		inContext: DASTContext new
		overlayIndex: nil.
	self assert: (pointOverlay overlays: #x).
	self deny: (pointOverlay overlays: #y)
]
