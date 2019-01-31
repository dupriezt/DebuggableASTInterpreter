"
I store variables and its values. I also contain a reference to my parent context. My method find: looks for a variable in myself and up in my predecessor contexts
"
Class {
	#name : #DASTContext,
	#superclass : #Object,
	#instVars : [
		'variablesDict',
		'parent'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTContext >> at: aByteSymbol put: anObject [
	"store variable and its value. TODO: implement the modification of variables in parent context"
	variablesDict at: aByteSymbol put: anObject
]

{ #category : #accessing }
DASTContext >> find: aByteSymbol [
	"store variable and its value.
	In case this context redefines a variable defined by its parent context, this method will return the variable value for this context"
	^ variablesDict at: aByteSymbol ifAbsent: [ 
		parent 
			ifNil: [ nil ] 
			ifNotNil: [ :pc | pc find: aByteSymbol ]
		 ]
]

{ #category : #accessing }
DASTContext >> initialize [
	super initialize.
	variablesDict := Dictionary new
]

{ #category : #accessing }
DASTContext >> initializeInContext: aDASTContext [
	"initializes an empty context whose parent is aDASTContext"
	parent := aDASTContext
]

{ #category : #accessing }
DASTContext >> isEmpty [
	
	^ variablesDict isEmpty.
]

{ #category : #accessing }
DASTContext >> parent [
	^ parent
]

{ #category : #accessing }
DASTContext >> variablesDict [
	^ variablesDict
]
