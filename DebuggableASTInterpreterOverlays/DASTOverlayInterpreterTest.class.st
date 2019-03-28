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

{ #category : #'overlay counter' }
DASTOverlayInterpreterTest >> testOverlayCounterCount [
	interpreter evaluate.
	self assert: interpreter overlayCounter equals: 4
]

{ #category : #'overlay counter' }
DASTOverlayInterpreterTest >> testOverlayCounterInitialization [
	self assert: interpreter overlayCounter equals: 0
]

{ #category : #'overlay history' }
DASTOverlayInterpreterTest >> testOverlayHistoryFirstElement [
	| instVarOverlay |
	interpreter evaluate.
	instVarOverlay := interpreter objectStateOverlay values first overlayHistory first.
	self assert: instVarOverlay varName equals: #x.
	self assert: instVarOverlay overlayValue equals: 5.
	self assert: instVarOverlay node isAssignment.
	self assert: instVarOverlay dastContext receiver == interpreter objectStateOverlay values first overlayedObject
]

{ #category : #'overlay history' }
DASTOverlayInterpreterTest >> testOverlayHistorySize [
	| history |
	interpreter evaluate.
	history := interpreter objectStateOverlay values first overlayHistory.
	self assert: history size equals: 4
]

{ #category : #'overlay history' }
DASTOverlayInterpreterTest >> testOverlayObjectState [
	| overlay |
	interpreter evaluate.
	overlay := interpreter objectStateOverlay values first.
	self assert: (overlay overlays: #x).
	self assert: (overlay overlays: #y)
]

{ #category : #'overlay counter' }
DASTOverlayInterpreterTest >> testOverlaysForProgramCounter [
	|objectOverlay|
	interpreter evaluate.
	objectOverlay := interpreter objectStateOverlay values first.
	self assert: interpreter overlaysForPC size equals: 4.
	self assert: (interpreter overlaysForPC includesKey: 1).
	self assert: (interpreter overlaysForPC includesKey: 2).
	self assert: (interpreter overlaysForPC includesKey: 3).
	self assert: (interpreter overlaysForPC includesKey: 4).
	self assert: (interpreter overlaysForPC at: 1) == objectOverlay.
	self assert: (interpreter overlaysForPC at: 2) == objectOverlay.
	self assert: (interpreter overlaysForPC at: 3) == objectOverlay.
	self assert: (interpreter overlaysForPC at: 4) == objectOverlay.
]

{ #category : #'overlay counter' }
DASTOverlayInterpreterTest >> testOverlaysForProgramCounterInitialization [
	self assert: interpreter overlaysForPC isEmpty
]

{ #category : #'execution reversing' }
DASTOverlayInterpreterTest >> testReverseExecutionToLastOverlay [
]

{ #category : #'execution reversing' }
DASTOverlayInterpreterTest >> testReverseStep [
	"Current implementation of program counter is not sufficient enough to find overlays related to a stepping operation"
	self skip
]

{ #category : #'overlay rollback' }
DASTOverlayInterpreterTest >> testRollbackToGivenOverlay [
]

{ #category : #'overlay rollback' }
DASTOverlayInterpreterTest >> testRollbackToOrigin [
]

{ #category : #'overlay rollback' }
DASTOverlayInterpreterTest >> testRollbackToPreviousOverlay [
]
