Extension { #name : #DASTContext }

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> node [
	^ self nodes last
]

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> operandStackAt: anInteger [
	^ self stack at: anInteger
]

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> operandStackPop [
	^ self stack pop
]

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> operandStackPush: aValue [
	^ self stack push: aValue
]

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> temporaryNamed: temporaryName [
	^ self variablesDict at: temporaryName ifAbsent: [ ^ nil ]
]

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> temporaryNamed: temporaryName put: newValue [
	self variablesDict at: temporaryName ifPresent: [ self variablesDict at: temporaryName put: newValue ].
]

{ #category : #'*DebuggableASTInterpreter-SindarinAdapter' }
DASTContext >> temporaryNames [
	^ self tempNames
]
