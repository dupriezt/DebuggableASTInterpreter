Class {
	#name : #DASTOverlayInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter',
		'point',
		'overlayHandler',
		'pointOverlay'
	],
	#category : #'DebuggableASTInterpreterOverlays-Tests'
}

{ #category : #running }
DASTOverlayInterpreterTest >> sampleProgram [
	| p |
	p := 4 @ 2.
	p setX: 5 setY: 3.
	p setX: 6 setY: 4.
	^ p
]

{ #category : #running }
DASTOverlayInterpreterTest >> sampleProgramAST [
	^(self class >> #sampleProgram) ast
]

{ #category : #running }
DASTOverlayInterpreterTest >> setUp [
	super setUp.
	interpreter := DASTOverlayInterpreter new.
	interpreter initializeWithProgram: self sampleProgramAST
]

{ #category : #tests }
DASTOverlayInterpreterTest >> testOverlayHistoryFirstElement [
	| instVarOverlay |
	interpreter evaluate.
	instVarOverlay := interpreter objectStateOverlay values first overlayHistory first.
	self assert: instVarOverlay varName equals: #x.
	self assert: instVarOverlay overlayValue equals: 5.
	self assert: instVarOverlay node isAssignment.
	self assert: instVarOverlay dastContext receiver == interpreter objectStateOverlay values first overlayedObject
]

{ #category : #tests }
DASTOverlayInterpreterTest >> testOverlayHistorySize [
	| history |
	interpreter evaluate.
	history := interpreter objectStateOverlay values first overlayHistory.
	self assert: history size equals: 4
]

{ #category : #tests }
DASTOverlayInterpreterTest >> testOverlayObjectState [
	| overlay |
	interpreter evaluate.
	overlay := interpreter objectStateOverlay values first.
	self assert: (overlay overlays: #x).
	self assert: (overlay overlays: #y)
]
