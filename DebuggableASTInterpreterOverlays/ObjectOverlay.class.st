Class {
	#name : #ObjectOverlay,
	#superclass : #Object,
	#instVars : [
		'overlayedObject',
		'overlayHistory',
		'overlayState'
	],
	#category : #'DebuggableASTInterpreterOverlays-Interpreter - version'
}

{ #category : #'instance creation' }
ObjectOverlay class >> on: anObject [ 
	|overlay|
	overlay := self new.
	overlay overlayedObject: anObject.
	^overlay
]

{ #category : #initialization }
ObjectOverlay >> initialize [
	overlayHistory := OrderedCollection new.
	overlayState := Dictionary new
]

{ #category : #accessing }
ObjectOverlay >> overlayHistory [
	^ overlayHistory
]

{ #category : #accessing }
ObjectOverlay >> overlayedObject [
	^ overlayedObject
]

{ #category : #accessing }
ObjectOverlay >> overlayedObject: anObject [
	overlayedObject := anObject
]

{ #category : #testing }
ObjectOverlay >> overlays: anInstVarName [
	^overlayState includesKey: anInstVarName
]

{ #category : #writing }
ObjectOverlay >> readInstanceVariableNamed: name ifAbsent: aBlock [
	^ overlayState at: name ifAbsent: aBlock
]

{ #category : #writing }
ObjectOverlay >> write: value toInstVarNamed: name fromNode: aNode inContext: aDastContext [
	|instVarOverlay|
	instVarOverlay := InstanceVariableOverlay new.
	instVarOverlay varName: name.
	instVarOverlay overlayValue: value.
	instVarOverlay node: aNode.
	instVarOverlay dastContext: (DASTContext new copyFrom: aDastContext).
	overlayState at: name put: value.
	overlayHistory add: instVarOverlay 
	
]
