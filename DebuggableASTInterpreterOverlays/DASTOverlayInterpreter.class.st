"
Experimental.
The DASTOverlayInterpreter uses ""overlays"" when reading and writing to object to debug a program in isolation. That version uses a local dictionary as a global object overlay.
"
Class {
	#name : #DASTOverlayInterpreter,
	#superclass : #DASTInterpreter,
	#instVars : [
		'objectStateOverlay'
	],
	#category : #DebuggableASTInterpreterOverlays
}

{ #category : #accessing }
DASTOverlayInterpreter >> objectStateOverlay [
	^ objectStateOverlay
		ifNil: [ objectStateOverlay := IdentityDictionary new ]
]

{ #category : #visiting }
DASTOverlayInterpreter >> readInstanceVariableNamed: name [
	| objectOverlay |
	objectOverlay := self objectStateOverlay
		at: self receiver
		ifAbsent: [ ^ super readInstanceVariableNamed: name ].
	^ objectOverlay
		at: name
		ifAbsent: [ ^ super readInstanceVariableNamed: name ]
]

{ #category : #visiting }
DASTOverlayInterpreter >> write: value toInstVarNamed: name [
	| objectOverlay |
	objectOverlay := self objectStateOverlay
		at: self receiver
		ifAbsentPut: [ Dictionary new ].
	objectOverlay at: name put: value
]
