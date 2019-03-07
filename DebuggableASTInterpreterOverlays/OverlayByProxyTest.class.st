Class {
	#name : #OverlayByProxyTest,
	#superclass : #TestCase,
	#instVars : [
		'point',
		'overlayHandler',
		'pointOverlay'
	],
	#category : #DebuggableASTInterpreterOverlays
}

{ #category : #running }
OverlayByProxyTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	point := 16@7.
	overlayHandler := OverlayHandler new. 
	pointOverlay := GHTargetBasedProxy createProxyFor: point handler: overlayHandler
]

{ #category : #tests }
OverlayByProxyTest >> testClassMessageIsNotIntercepted [
	self assert: pointOverlay class == Point
]

{ #category : #tests }
OverlayByProxyTest >> testInitiallyOverlayIsEmpty [
	self assert: overlayHandler isEmpty
]

{ #category : #tests }
OverlayByProxyTest >> testReadInstanceVariableFetchesFirstOverlayValue [
	pointOverlay instVarNamed: #x put: 1.
	self assert: (pointOverlay instVarNamed: #x) equals: 1
]

{ #category : #tests }
OverlayByProxyTest >> testReadInstanceVariableFetchesOriginalValueIfNotOverlayed [
	pointOverlay instVarNamed: #x put: 1.
	self assert: (pointOverlay instVarNamed: #y) equals: 7
]

{ #category : #tests }
OverlayByProxyTest >> testWrittenInstanceVariableDoesNotTouchProxifiedObject [
	pointOverlay instVarNamed: #x put: 1.
	self assert: point x equals: 16
]

{ #category : #tests }
OverlayByProxyTest >> testWrittenInstanceVariableIsOverlayed [
	pointOverlay instVarNamed: #x put: 1.
	self deny: overlayHandler isEmpty
]
