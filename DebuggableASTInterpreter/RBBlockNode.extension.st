Extension { #name : #RBBlockNode }

{ #category : #'*DebuggableASTInterpreter' }
RBBlockNode >> canBeTracePoint [
	^ self parent isSequence not
]

{ #category : #'*DebuggableASTInterpreter' }
RBBlockNode >> sourceCode [
	^ [ super sourceCode ] on: Exception do: [ '' ]
]
