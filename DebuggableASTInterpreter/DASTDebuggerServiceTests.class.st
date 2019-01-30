Class {
	#name : #DASTDebuggerServiceTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTDebuggerServiceTests >> testInterpretAllWithoutBreakPoints [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: '1'.
	ds runInterpreter.
	
]
