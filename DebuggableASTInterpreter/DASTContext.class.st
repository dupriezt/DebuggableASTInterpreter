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
	| varSet |
		"if the variable is already declared, I modify its value"
	
	((self parent class = DASTContextRootSmalltalk ) or: [self variablesDict includes: aByteSymbol ]) 
	ifTrue: [ 
		variablesDict at: aByteSymbol put: anObject.
		^ anObject
		 ].
	"since a block can modify its outer context variables, 
	it's necessary to check if the variable is defined in an antecesor context"
	varSet := self parent update: aByteSymbol put: anObject.
	
	varSet ifNil: [ 
		"the variable wasn't updated, I have to create it"
		 self variablesDict at: aByteSymbol put: anObject
		]
	
]

{ #category : #accessing }
DASTContext >> find: aByteSymbol [
	
	"Return the value of a variable.
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

{ #category : #'as yet unclassified' }
DASTContext >> update: aByteSymbol put: anObject [
	"if the variable is already declared, I modify its value"
	((self parent class = DASTContextRootSmalltalk ) or: [self variablesDict includes: aByteSymbol ])
	ifTrue: [ 
		variablesDict at: aByteSymbol put: anObject.
		^ anObject
		 ].

	^ self parent update: aByteSymbol put: anObject.
	
]

{ #category : #accessing }
DASTContext >> variablesDict [
	^ variablesDict
]
