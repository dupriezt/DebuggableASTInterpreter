Extension { #name : #RBVariableNode }

{ #category : #'*DebuggableASTInterpreter' }
RBVariableNode >> canBeTracePoint [
	^ (self parent isAssignment 
			and: [ self parent children last = self ]) not
]

{ #category : #'*DebuggableASTInterpreter' }
RBVariableNode >> isVariableNameInAssignation [
	"true if the variable appears at left of :="
	^self parent isAssignment and: [ self parent children second = self ]
]
