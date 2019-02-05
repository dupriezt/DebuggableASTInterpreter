"
I store variables and its values. I also contain a reference to my parent context. My method find: looks for a variable in myself and up in my predecessor contexts
"
Class {
	#name : #DASTContext,
	#superclass : #Object,
	#instVars : [
		'variablesDict',
		'parent',
		'receiver'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTContext >> at: aByteSymbol put: anObject [
	^self variablesDict at: aByteSymbol put: anObject.
	
	
]

{ #category : #accessing }
DASTContext >> at: aByteSymbol putInHierarchy: anObject [
	| node |
	node := self nodeContainingVariable: aByteSymbol.
	node ifNil: [ node := self ].
	^ node variablesDict at: aByteSymbol put: anObject
	
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
DASTContext >> isEmpty [
	
	^ variablesDict isEmpty.
]

{ #category : #accessing }
DASTContext >> isRoot [ 
	^false
]

{ #category : #accessing }
DASTContext >> lookupSelector: aByteString [

	^ receiver systemClass lookupSelector: aByteString.
]

{ #category : #accessing }
DASTContext >> nodeContainingVariable: aByteSymbol [
	((self variablesDict keys includes: aByteSymbol) or: [self parent isRoot]) 
		ifTrue: [ ^ self ]
		ifFalse: [ ^ parent nodeContainingVariable: aByteSymbol ]
]

{ #category : #accessing }
DASTContext >> parent [
	^ parent
]

{ #category : #accessing }
DASTContext >> parent: aDASTContext [
	parent := aDASTContext
]

{ #category : #accessing }
DASTContext >> receiver [ 
	^ receiver
]

{ #category : #accessing }
DASTContext >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
DASTContext >> variablesDict [
	^ variablesDict
]
