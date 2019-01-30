Class {
	#name : #DASTDebuggerServiceTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTDebuggerServiceTests >> testInterpretAllWithoutBreakPoints [
	| ds retVal |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: '1'.
	
	retVal := ds runInterpreter.
	self assert: retVal equals: 1.
	
]

{ #category : #tests }
DASTDebuggerServiceTests >> testInterpretComplexMessageAllWithoutBreakPoint [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: 'x:=1 . x:= x+2 . x'.
	Transcript show: ds currentNode asString;cr.
	ds runInterpreter.
	Transcript show: ds currentNode asString;cr.
	Transcript show: 'esperar';cr.
	
]
