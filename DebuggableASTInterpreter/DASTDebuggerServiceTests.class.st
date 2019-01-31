Class {
	#name : #DASTDebuggerServiceTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTDebuggerServiceTests >> testAddBreakpoint [
	| ds ast nodeBreak |
	ds := DASTDebuggerService new.
	ast := (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	ds initializeWithProgram: ast.
	self assert: ds breakpoints isEmpty.
	nodeBreak := ast children first.
	ds addBreakPointAt: nodeBreak.
	self assert: (ds isBreakpoint: nodeBreak).
]

{ #category : #tests }
DASTDebuggerServiceTests >> testInterpretAllWithoutBreakPoints [
	| ds retVal |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: (RBParser parseExpression: '1').
	
	retVal := ds runInterpreter.
	self assert: retVal equals: 1.
	
]

{ #category : #tests }
DASTDebuggerServiceTests >> testInterpretComplexMessageAllWithoutBreakPoint [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	Transcript show: ds currentNode asString;cr.
	ds runInterpreter.
	Transcript show: ds currentNode asString;cr.
	Transcript show: 'esperar';cr.
	
]
