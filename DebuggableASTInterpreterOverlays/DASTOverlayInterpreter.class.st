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
	#category : #'DebuggableASTInterpreterOverlays-Interpreter - version'
}

{ #category : #accessing }
DASTOverlayInterpreter >> objectStateOverlay [
	^ objectStateOverlay
		ifNil: [ objectStateOverlay := IdentityDictionary new ]
]

{ #category : #visiting }
DASTOverlayInterpreter >> overlayFor: anObject [
	^ self objectStateOverlay
		at: self receiver
		ifAbsentPut: [ ObjectOverlay on: self receiver ]
]

{ #category : #visiting }
DASTOverlayInterpreter >> readInstanceVariableNamed: name [
	^ (self overlayFor: self receiver)
		readInstanceVariableNamed: name
		ifAbsent: [ ^ super readInstanceVariableNamed: name ]
]

{ #category : #visiting }
DASTOverlayInterpreter >> write: value toInstVarNamed: name [
	(self overlayFor: self receiver)
		write: value
		toInstVarNamed: name
		fromNode: self currentNode parent
		inContext: self currentContext
]
