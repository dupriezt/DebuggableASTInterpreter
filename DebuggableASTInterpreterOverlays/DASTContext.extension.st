Extension { #name : #DASTContext }

{ #category : #'*DebuggableASTInterpreterOverlays' }
DASTContext >> copyFrom: aDastContext [
	variablesDict := aDastContext variablesDict copy.
	receiver := aDastContext receiver.
	nodes := aDastContext nodes copy.
	stack := aDastContext stack copy.
	closure := aDastContext methodOrBlock.
	messageNode := aDastContext messageNode.
	sender := aDastContext sender.
	tempVarIndex := aDastContext tempVarIndex.
	tempVarsNamesIndexes := aDastContext tempVarNamesIndexes.
]

{ #category : #'*DebuggableASTInterpreterOverlays' }
DASTContext >> tempVarIndex [
	^tempVarIndex
]

{ #category : #'*DebuggableASTInterpreterOverlays' }
DASTContext >> tempVarNamesIndexes [
	^tempVarsNamesIndexes
]
