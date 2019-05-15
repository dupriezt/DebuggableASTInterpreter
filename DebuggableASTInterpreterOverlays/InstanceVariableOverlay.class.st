Class {
	#name : #InstanceVariableOverlay,
	#superclass : #Object,
	#instVars : [
		'varName',
		'overlayValue',
		'node',
		'dastContext'
	],
	#category : #'DebuggableASTInterpreterOverlays-Interpreter - version'
}

{ #category : #accessing }
InstanceVariableOverlay >> dastContext [
	^ dastContext
]

{ #category : #accessing }
InstanceVariableOverlay >> dastContext: anObject [
	dastContext := anObject
]

{ #category : #accessing }
InstanceVariableOverlay >> node [
	^ node
]

{ #category : #accessing }
InstanceVariableOverlay >> node: anObject [
	node := anObject
]

{ #category : #accessing }
InstanceVariableOverlay >> overlayValue [
	^ overlayValue
]

{ #category : #accessing }
InstanceVariableOverlay >> overlayValue: anObject [
	overlayValue := anObject
]

{ #category : #accessing }
InstanceVariableOverlay >> varName [
	^ varName
]

{ #category : #accessing }
InstanceVariableOverlay >> varName: anObject [
	varName := anObject
]
