"
I can interpret a program represented as an AST tree
"
Class {
	#name : #DASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'currentNode',
		'stack',
		'currentContext'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #contexts }
DASTInterpreter >> currentContext [
	^ currentContext.
]

{ #category : #evaluation }
DASTInterpreter >> evaluate [
	^ currentNode acceptVisitor: self
]

{ #category : #stepping }
DASTInterpreter >> evaluateNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : #initialization }
DASTInterpreter >> initialize [
	super initialize.
	currentContext := DASTContext new.	
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [ 
	currentNode := aRBNode
]

{ #category : #visiting }
DASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	| name value |
	"The evaluation is eager, therefore the stack will contain the value already evaluated"
	self assert: (aRBAssignmentNode children size = 2).
	name := aRBAssignmentNode children last acceptVisitor: self.
	value := aRBAssignmentNode children first acceptVisitor: self.
	self currentContext at: name put: value.
	^ value
	
]

{ #category : #visiting }
DASTInterpreter >> visitBlockNode: aRBBlockNode [ 
	"A new context must be created, and its parent must be the current context"
	
	| blockContext |
	blockContext := DASTContext new initializeInContext: currentContext.
	currentContext := blockContext 
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 

	^ aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	| arguments receiver receiverNode argumentsNodes |
	
	receiverNode := aRBMessageNode children first.
	receiver := receiverNode acceptVisitor: self.
	
	argumentsNodes := aRBMessageNode children allButFirst.
	arguments := argumentsNodes collect: [:node | node acceptVisitor: self].
	
	^ receiver perform: aRBMessageNode selector withArguments: arguments asArray
]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	| results |
	results := aRBSequenceNode children collect: [:node | node acceptVisitor: self].
	^ results last
]

{ #category : #visiting }
DASTInterpreter >> visitVariableNode: aRBVariableNode [
	| varName |
	varName := aRBVariableNode name.
	^ (aRBVariableNode parent isAssignment 
			ifTrue: [ varName ]
			ifFalse: [ currentContext find: varName  ])
]
