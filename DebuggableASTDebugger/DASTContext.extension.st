Extension { #name : #DASTContext }

{ #category : #'*DebuggableASTDebugger' }
DASTContext >> currentNode [ 	
	^self nodes top
]

{ #category : #'*DebuggableASTDebugger' }
DASTContext >> messageNode [
	^messageNode
]

{ #category : #'*DebuggableASTDebugger' }
DASTContext >> top [
	stack ifEmpty: [ ^ #emptyStack ].
	^ stack top
]
