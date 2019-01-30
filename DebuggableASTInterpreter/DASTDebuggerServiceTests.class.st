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
	self assert: ds runInterpreter equals: 1.
	
]

{ #category : #tests }
DASTDebuggerServiceTests >> testInterpretComplexMessageAllWithoutBreakPoint [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: 'x:=1 . x:= x+2 . x'.
	self assert: ds runInterpreter equals: 3.
	
]
