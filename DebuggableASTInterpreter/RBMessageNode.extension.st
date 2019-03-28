Extension { #name : #RBMessageNode }

{ #category : #'*DebuggableASTInterpreter' }
RBMessageNode >> isLastCascaded [
	^self isCascaded and: [parent messages last == self]
]
