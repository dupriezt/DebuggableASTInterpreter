"
I store variables and its values. I also contain a reference to my parent context. My method find: looks for a variable in myself and up in my predecessor contexts
"
Class {
	#name : #DASTContext,
	#superclass : #Object,
	#instVars : [
		'variablesDict',
		'receiver',
		'method',
		'hasReturned',
		'nodes',
		'stack',
		'senderContext',
		'parent'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #accessing }
DASTContext >> at: aByteSymbol put: anObject [
	^self variablesDict at: aByteSymbol put: anObject.
	
	
]

{ #category : #accessing }
DASTContext >> at: aByteSymbol putInHierarchy: anObject [
	| definingContext |
	definingContext := self lookupContextDefining: aByteSymbol.
	definingContext ifNil: [ definingContext := self ].
	^ definingContext variablesDict at: aByteSymbol put: anObject
	
]

{ #category : #accessing }
DASTContext >> definesVariableNamed: aName [
	"Return if the variable is locally defined as a temporary or as an argument"
	^ self variablesDict keys includes: aName
]

{ #category : #accessing }
DASTContext >> find: aByteSymbol [
	| value |
	value := receiver isClass ifTrue: [ receiver bindingOf: aByteSymbol ].
	value ifNotNil: [ ^ value ].
	"Return the value of a variable.
	In case this context redefines a variable defined by its parent context, this method will return the variable value for this context"
	^ variablesDict at: aByteSymbol ifAbsent: [ 
		parent 
			ifNil: [ self error: 'Variable ', aByteSymbol , ' not defined!'  ] 
			ifNotNil: [ :pc | pc find: aByteSymbol ]
		 ]
]

{ #category : #accessing }
DASTContext >> findInstVarNamed: aName [
	^  self receiver instVarNamed: aName
]

{ #category : #accessing }
DASTContext >> hasReturned [ 
	^ hasReturned
]

{ #category : #accessing }
DASTContext >> initialize [
	super initialize.
	hasReturned := false.
	stack := Stack new.
	variablesDict := Dictionary new
]

{ #category : #accessing }
DASTContext >> isBlockContext [

	^ method isBlock
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
DASTContext >> lookupContextDefining: aByteSymbol [
	
	(self definesVariableNamed: aByteSymbol) ifTrue: [ ^ self ].
	
	^ self isBlockContext
		ifTrue: [ method outerContext lookupContextDefining: aByteSymbol ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
DASTContext >> lookupSelector: aByteString [
	| aClass |
	aClass := (receiver isNil and: [ aByteString = #value ]) 
		ifTrue: [ BlockClosure ] "ugly hack to handle the first block value with nil as receiver"
		ifFalse: [ receiver systemClass ].
		
	 ^aClass lookupSelector: aByteString.
]

{ #category : #accessing }
DASTContext >> method [
	^ method
]

{ #category : #accessing }
DASTContext >> method: aMethod [

	method := aMethod
]

{ #category : #accessing }
DASTContext >> nodes [ 
	^nodes ifNil: [ nodes := Stack new ]
]

{ #category : #accessing }
DASTContext >> nodes: aStack [ 
	nodes := aStack
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
DASTContext >> printOn: aStream [
	aStream
		cr;
		nextPutAll: receiver asString;
		nextPutAll: ' <- ';
		nextPutAll: method selector asString.
]

{ #category : #accessing }
DASTContext >> receiver [
	
	^ self isBlockContext
		ifTrue: [ method outerContext receiver ]
		ifFalse: [ receiver ]
]

{ #category : #accessing }
DASTContext >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
DASTContext >> senderContext [
	^ senderContext
]

{ #category : #accessing }
DASTContext >> senderContext: aDASTContext [
	senderContext := aDASTContext
]

{ #category : #accessing }
DASTContext >> setAsReturned [
	hasReturned := true.
	"if I'm the context of a block and I return, I must mark my parents as returned until I reach a method node" 
	self isBlockContext 
		ifTrue: [ self parent setAsReturned ]
	
]

{ #category : #accessing }
DASTContext >> stack [
	^ stack
]

{ #category : #accessing }
DASTContext >> stack: anObject [
	stack := anObject
]

{ #category : #accessing }
DASTContext >> variablesDict [
	^ variablesDict
]
