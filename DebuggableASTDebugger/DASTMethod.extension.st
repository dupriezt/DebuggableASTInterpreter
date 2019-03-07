Extension { #name : #DASTMethod }

{ #category : #'*DebuggableASTDebugger' }
DASTMethod >> methodClass [ 	
	^self nodeAST methodClass
]

{ #category : #'*DebuggableASTDebugger' }
DASTMethod >> source [
	^self nodeAST source
]
