"
I store variables and its values. I also contain a reference to my parent context. My method find: looks for a variable in myself and up in my predecessor contexts
"
Class {
	#name : #DASTContext,
	#superclass : #Object,
	#instVars : [
		'variablesDict',
		'receiver',
		'nodes',
		'stack',
		'parent',
		'closure',
		'messageNode',
		'sender',
		'tempVarIndex',
		'tempVarsNamesIndexes'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #'API-store' }
DASTContext >> at: aByteSymbol put: anObject [
	self setIndexForTempVarNamed: aByteSymbol.
	^self variablesDict at: aByteSymbol put: anObject.
	
	
]

{ #category : #'closure support' }
DASTContext >> contextTag [
	^ self
]

{ #category : #'accessing - private' }
DASTContext >> definesLocalVariableNamed: aName [
	"Return true if the context defines the local variable"
	^ self variablesDict keys includes: aName
]

{ #category : #'API-lookup' }
DASTContext >> findClassVariable: aName [
	^ receiver isClass 
		ifTrue: [ receiver bindingOf: aName ]
		ifFalse:[ receiver systemClass bindingOf: aName ]
]

{ #category : #query }
DASTContext >> findContextSuchThat: testBlock [
	"Search self and my sender chain for first one that satisfies testBlock.  Return nil if none satisfy"

	| context |
	context := self.
	[ context isNil ] whileFalse: [
		(testBlock value: context) 
			ifTrue: [ ^ context ].
		context := context sender ].
	^ nil
]

{ #category : #'API-lookup' }
DASTContext >> findInstanceVariable: aName [
	[^ aName -> (self receiver instVarNamed: aName) ]
		on: InstanceVariableNotFound do: [ ^nil ] 
]

{ #category : #'API-lookup' }
DASTContext >> findLocalVariable: aName [

	^ variablesDict 
		associationAt: aName 
		ifAbsent: [ nil ]
]

{ #category : #'private-exceptions' }
DASTContext >> findNextHandlerContext [
	"Return the next handler marked context, returning nil if there is none.  Search starts with self and proceeds up to nil."

	| context |
	context := self findNextHandlerOrSignalingContext.
	context isNil
		ifTrue: [ ^ nil ].
	context isHandlerContext
		ifTrue: [ ^ context ].	"If it isn't a handler context, it must be a signaling context.
	When we reach a signaling context we must skip over any handlers
	that might be on the stack between the signaling context and the handler
	context for that signal."
	^ context exception privHandlerContext nextHandlerContext
]

{ #category : #'private-exceptions' }
DASTContext >> findNextHandlerOrSignalingContext [
	"Return the next handler/signaling marked context, answering nil if there is none. 
	Search starts with self and proceeds up to nil."

	"<primitive: 197>"
	| context |
	context := self.
	[ 
	context isHandlerOrSignalingContext
		ifTrue: [ ^ context ].
	(context := context sender) == nil ] whileFalse.
	^ nil
]

{ #category : #'API-lookup' }
DASTContext >> findVariable: aByteSymbol [
	|association|
	"Return the value of a variable. If this context redefines a variable defined by its parent context, this method will return the variable value for this context"
	
	"class variables"
	association := self findClassVariable: aByteSymbol.
	association ifNotNil: [ ^ association value ].
	
	"instance variables"
	association := self findInstanceVariable: aByteSymbol.
	association ifNotNil: [ ^ association value ].
	
	"local variables"
	association := self findLocalVariable: aByteSymbol.
	association ifNotNil: [ ^ association value ].
	
	^ parent 
			ifNil: [ self error: 'Variable ', aByteSymbol , ' not defined!'  ] 
			ifNotNil: [ :pc | pc findVariable: aByteSymbol ]
]

{ #category : #'accessing - private' }
DASTContext >> getClassForLookup [
	| aClass |
	
	aClass := self receiver systemClass.
	 ^ aClass := (messageNode isSuperSend 
			ifTrue: [messageNode methodNode methodClass superclass] 
			ifFalse: [aClass]) .
]

{ #category : #initialization }
DASTContext >> initialize [
	super initialize.
	stack := DASTStack new.
	variablesDict := Dictionary new.
	tempVarsNamesIndexes := Dictionary new.
	tempVarIndex := 0
]

{ #category : #initialization }
DASTContext >> initializeWithParent: aDASTContext receiver: aReceiver messageNode: aRBMessageNode [ 
	
	| parentContext compiledMethod theMethod visitor aClass aSelector |
	parentContext := aReceiver isBlock 
		ifTrue: [ aReceiver outerContext ]
		ifFalse: [ aDASTContext ].
	
	self	parent: parentContext;
			receiver: aReceiver;			
			sender: aDASTContext;
			messageNode: aRBMessageNode .
	aSelector := aRBMessageNode selector.
	
	aClass := (self receiver isNil and: [ aSelector = #value ]) 
		ifTrue: [ BlockClosure ]
		ifFalse: [ self getClassForLookup ].
	
	compiledMethod := self lookupSelector: aSelector startInClass: aClass.

	theMethod := (aReceiver isBlock and: [ compiledMethod isKindOfValue ])
		ifTrue: [ aReceiver ]
		ifFalse: [ DASTMethod new initializeWith: compiledMethod ast outerContext: aDASTContext ].
		
	visitor := DASTPostOrderTreeVisitor new.
	(theMethod doSemanticAnalysis body) acceptVisitor: visitor.
	nodes := visitor stack.
	
	self 	methodOrBlock: theMethod;
			nodes: nodes.
	
]

{ #category : #testing }
DASTContext >> isBlockContext [

	^ closure isBlock
]

{ #category : #testing }
DASTContext >> isEmpty [
	
	^ variablesDict isEmpty.
]

{ #category : #'private-exceptions' }
DASTContext >> isHandlerContext [
	"is this context for #on:do:?"
	^self isHandlerOrSignalingContext and: [ self selector == #on:do: ]
]

{ #category : #'private-exceptions' }
DASTContext >> isHandlerOrSignalingContext [
	"Both BlockClosure>>on:do: (handler) and Context>>evaluateSignal: (signaling) 
	are marked with primitive 199."
	self flag: 'aqui se va a caer'.
	^closure isBlock not and:  [closure primitive = 199]
]

{ #category : #testing }
DASTContext >> isRoot [ 
	^false
]

{ #category : #'accessing - private' }
DASTContext >> lookupContextDefiningLocalVariable: aByteSymbol [
	
	(self definesLocalVariableNamed: aByteSymbol) ifTrue: [ ^ self ].
	
	^ self isBlockContext
		ifTrue: [ closure outerContext lookupContextDefiningLocalVariable: aByteSymbol ]
		ifFalse: [ nil ]
]

{ #category : #'API-lookup' }
DASTContext >> lookupSelector: aByteString startInClass: aClass [ 
	^(aClass lookupSelector: aByteString)
		ifNil: [ "ToDo: implement does not understand" 
					self error: 'The class ',aClass asString,' does not understand the message: ', aByteString asString ].
	
]

{ #category : #accessing }
DASTContext >> messageNode: aRBMessageNode [ 
	messageNode := aRBMessageNode
]

{ #category : #accessing }
DASTContext >> methodOrBlock [
	^ closure
]

{ #category : #accessing }
DASTContext >> methodOrBlock: aDASTClosure [

	closure := aDASTClosure
]

{ #category : #'private-exceptions' }
DASTContext >> nextHandlerContext [

	^ self sender findNextHandlerContext
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
	" This is the context in which this context was created. 
	  This context is used for performing the lookup operations "
	^ parent
]

{ #category : #accessing }
DASTContext >> parent: aDASTContext [
	" This is the context in which this context was created. 
	  This context is used for performing the lookup operations "
	parent := aDASTContext
]

{ #category : #accessing }
DASTContext >> printOn: aStream [
	aStream
		cr;
		nextPutAll: (receiver ifNotNil: [ receiver asString ] ifNil: [ 'nil' ]);
		nextPutAll: ' <- ';
		nextPutAll: (closure ifNotNil: [ closure selector asString ] ifNil: ['nil']).
]

{ #category : #accessing }
DASTContext >> receiver [
	
	^ self isBlockContext
		ifTrue: [ closure outerContext receiver ]
		ifFalse: [ receiver ]
]

{ #category : #accessing }
DASTContext >> receiver: anObject [
	receiver := anObject
]

{ #category : #modifying }
DASTContext >> removePrimitiveFromMethod [
	
	closure nodeAST removePragma: (closure nodeAST pragmas select: [ :p | p isPrimitive ]) first
]

{ #category : #accessing }
DASTContext >> returnContext [ 
	^self isBlockContext 
		ifTrue: [ ^ parent returnContext ]
		ifFalse: [ ^ sender  ]
]

{ #category : #accessing }
DASTContext >> selector [

	^closure selector ifNil: [closure defaultSelector].
]

{ #category : #accessing }
DASTContext >> sender [
	^ sender 
]

{ #category : #accessing }
DASTContext >> sender: aDASTContext [
	sender := aDASTContext
]

{ #category : #'API-store' }
DASTContext >> setIndexForTempVarNamed: tempVarName [
	tempVarsNamesIndexes
		at: tempVarName
		ifAbsentPut: [ tempVarIndex := tempVarIndex + 1 ]
]

{ #category : #accessing }
DASTContext >> setTemporalVariablesNamed: names values: values [
	values doWithIndex: 
		  [ :val :index | 
				self 
					at: (names at: index)
					 put: val ].
]

{ #category : #'accessing - private' }
DASTContext >> stack [
	^ stack
]

{ #category : #'accessing - private' }
DASTContext >> stack: anObject [
	stack := anObject
]

{ #category : #'accessing - private' }
DASTContext >> variablesDict [
	^ variablesDict
]
