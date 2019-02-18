Class {
	#name : #DASTPostOrderTreeVisitor,
	#superclass : #Object,
	#instVars : [
		'stack'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #visiting }
DASTPostOrderTreeVisitor >> initialize [ 

	super initialize.
	stack := Stack new
]

{ #category : #accessing }
DASTPostOrderTreeVisitor >> stack [
	^ stack
]

{ #category : #accessing }
DASTPostOrderTreeVisitor >> top [
	
	^ stack top
]

{ #category : #visiting }
DASTPostOrderTreeVisitor >> visitAssignmentNode: aRBAssignmentNode [ 

	stack push: aRBAssignmentNode.
	aRBAssignmentNode value acceptVisitor: self
]

{ #category : #visiting }
DASTPostOrderTreeVisitor >> visitLiteralNode: aRBLiteralValueNode [ 

	stack push: aRBLiteralValueNode
]

{ #category : #visiting }
DASTPostOrderTreeVisitor >> visitMessageNode: aRBMessageNode [ 

	stack push: aRBMessageNode.

	aRBMessageNode arguments reverse do: [ :e | e acceptVisitor: self ].
	aRBMessageNode receiver acceptVisitor: self.
]

{ #category : #visiting }
DASTPostOrderTreeVisitor >> visitReturnNode: aRBReturnNode [ 
	
	stack push: aRBReturnNode.

	aRBReturnNode value acceptVisitor: self
]

{ #category : #visiting }
DASTPostOrderTreeVisitor >> visitSequenceNode: aRBSequenceNode [ 

	stack push: aRBSequenceNode.
	aRBSequenceNode children reverse do: [ :e | e acceptVisitor: self ].	
]

{ #category : #visiting }
DASTPostOrderTreeVisitor >> visitVariableNode: aRBVariableNode [ 
	
	stack push: aRBVariableNode 
]
