"
I am a proxy handler which intercepts instance variable read and write from the DASTInterpreter. When such inst var access is intercepted values are read or written into an ""overlay"" instead of read/write in the original object.

If a instvar has not been overlayed, the real object's value is returned when reading.
"
Class {
	#name : #OverlayHandler,
	#superclass : #GHSimpleForwarderProxyHandler,
	#instVars : [
		'objectOverlay',
		'overlayDictionary'
	],
	#category : #DebuggableASTInterpreterOverlays
}

{ #category : #'handle - methods' }
OverlayHandler >> handleClass: target [

	^ target proxy proxyTarget class
]

{ #category : #'handle - methods' }
OverlayHandler >> handleReadInstVarNamed: interception [

	| variableName |
	variableName := interception message arguments first.
	^ self overlayDictionary
		at: variableName
		ifAbsent: [ interception proxy proxyTarget instVarNamed: variableName ]
]

{ #category : #'handle - methods' }
OverlayHandler >> handleWriteInstVarNamed: interception [

	| value |
	value := interception message arguments second.
	self overlayDictionary
		at: interception message arguments first
		put: value.
	^ value
]

{ #category : #testing }
OverlayHandler >> isEmpty [
	^ self overlayDictionary isEmpty
]

{ #category : #'handle - methods' }
OverlayHandler >> methodsMessagesToHandle [
	^ super methodsMessagesToHandle
		at: #class put: #handleClass:;
		at: #instVarNamed:put: put: #handleWriteInstVarNamed:;
		at: #instVarNamed: put: #handleReadInstVarNamed:;
		yourself
]

{ #category : #accessing }
OverlayHandler >> overlayDictionary [
	^ overlayDictionary ifNil: [ overlayDictionary := Dictionary new ]
]
