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

{ #category : #traversing }
DASTInterpreter >> deepestLeftChildOf: aNode [
	| deepestLeftChild |
	deepestLeftChild := aNode.
	[ deepestLeftChild children isEmpty ]
		whileFalse: [ deepestLeftChild := deepestLeftChild children first ].
	^ deepestLeftChild
]

{ #category : #evaluation }
DASTInterpreter >> evaluate [
	[ self nextNode: currentNode ] whileNotNil: [  
		self step
	].
	^ self pop
]

{ #category : #stepping }
DASTInterpreter >> evaluateNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : #initialization }
DASTInterpreter >> initialize [
	super initialize.
	currentContext := DASTContext new.	
	stack := Stack new.
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [ 
	currentNode := (self deepestLeftChildOf: aRBNode)
]

{ #category : #traversing }
DASTInterpreter >> nextNode: aNode [
	
	"If it is the last, we evaluate the parent"
	| sibling |
	aNode parent ifNil: [ ^nil ] .

	aNode parent children last = aNode
		ifTrue: [ ^ aNode parent ].
	
	"Then, we get the next child and we get it's deepest first child"
	sibling := aNode parent children after: aNode.
	^ self deepestLeftChildOf: sibling
]

{ #category : #'stack-management' }
DASTInterpreter >> pop [
	
	^ stack pop
]

{ #category : #'stack-management' }
DASTInterpreter >> pop: anInteger [ 
	
	| poppedElements |
	poppedElements := OrderedCollection new.
	anInteger timesRepeat: [ poppedElements addFirst: stack pop ].
	^ poppedElements
]

{ #category : #'stack-management' }
DASTInterpreter >> push: anObject [

	stack push: anObject
]

{ #category : #'stack-management' }
DASTInterpreter >> stack [
	^ stack
]

{ #category : #'stack-management' }
DASTInterpreter >> stackTop [
	
	^ stack top
]

{ #category : #stepping }
DASTInterpreter >> step [
	
	self evaluateNode: currentNode.
	currentNode := self nextNode: currentNode.
]

{ #category : #visiting }
DASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [ 
	| name value |
	"The evaluation is eager, therefore the stack will contain the value already evaluated"
	name := stack pop.
	value := stack top.
	self currentContext at: name put: value.
	
]

{ #category : #visiting }
DASTInterpreter >> visitBlockNode: aRBBlockNode [ 
	"When visiting a block node, I put it in the stack. The block will be evaluated only when it is the receiver of a message."
	self halt.
	self push: aRBBlockNode.
]

{ #category : #visiting }
DASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 
	
	self push: aRBLiteralValueNode value
]

{ #category : #visiting }
DASTInterpreter >> visitMessageNode: aRBMessageNode [ 
	"When visiting a message node, its arguments are already in the stack.
	This is because our interpreter iterates the tree in deep first post order"	
	
	| arguments receiver |
	arguments := self pop: aRBMessageNode arguments size.
	receiver := self pop.
	
	self push: (receiver perform: aRBMessageNode selector withArguments: arguments asArray)
]

{ #category : #visiting }
DASTInterpreter >> visitSequenceNode: aRBSequenceNode [ 
	^self
]

{ #category : #visting }
DASTInterpreter >> visitVariableNode: aRBVariableNode [ 
	self push: aRBVariableNode name
]
