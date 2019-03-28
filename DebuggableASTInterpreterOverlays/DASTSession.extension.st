Extension { #name : #DASTSession }

{ #category : #'*DebuggableASTInterpreterOverlays' }
DASTSession classSide >> debugWithOverlays: sourceCode [
	^self new debug: sourceCode
]

{ #category : #'*DebuggableASTInterpreterOverlays' }
DASTSession >> debugWithOverlays: sourceCode [
	interpreter := DASTOverlayInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: sourceCode).
	
]
