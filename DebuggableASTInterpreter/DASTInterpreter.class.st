Class {
	#name : #DASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'currentNode',
		'stack'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #recorrido }
DASTInterpreter >> deepestLeftChildOf: aNode [
	| deepestLeftChild |
	deepestLeftChild := aNode.
	[ deepestLeftChild children isEmpty ]
		whileFalse: [ deepestLeftChild := deepestLeftChild children first ].
	^ deepestLeftChild
]

{ #category : #stepping }
DASTInterpreter >> evaluateNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : #initialization }
DASTInterpreter >> initialize [
	super initialize.
	stack := Stack new.
]

{ #category : #initialization }
DASTInterpreter >> initializeWithProgram: aRBNode [ 
	
	currentNode := (self deepestLeftChildOf: aRBNode)
]

{ #category : #recorrido }
DASTInterpreter >> nextNode: aNode [
	
	"If it is the last, we evaluate the parent"
	| sibling |
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
