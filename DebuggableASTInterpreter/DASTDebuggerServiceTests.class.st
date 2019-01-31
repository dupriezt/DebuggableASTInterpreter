Class {
	#name : #DASTDebuggerServiceTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #'tests-breakpoints' }
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

{ #category : #'tests-breakpoints' }
DASTDebuggerServiceTests >> testRemoveAllBreakpoints [
	| ds ast nodeBreak1 nodeBreak2 nodeBreak3 |
	ds := DASTDebuggerService new.
	ast := (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	ds initializeWithProgram: ast.
	
	nodeBreak1 := ast children first. "Assignment x:=1"
	nodeBreak2 := ast children second. "Assignment x:= x+2"
	nodeBreak3 := ast children second children first "Method x+2". 
	
	ds addBreakPointAt: nodeBreak1.
	ds addBreakPointAt: nodeBreak2.
	ds addBreakPointAt: nodeBreak3.
	self assert: (ds isBreakpoint: nodeBreak1).
	self assert: (ds isBreakpoint: nodeBreak2).
	self assert: (ds isBreakpoint: nodeBreak3).
	
	ds removeAllBreakPoints.
	self assert: (ds breakpoints isEmpty).
	self assert: (ds isBreakpoint: nodeBreak1) not.
	self assert: (ds isBreakpoint: nodeBreak1) not.
	self assert: (ds isBreakpoint: nodeBreak1) not.
]

{ #category : #'tests-breakpoints' }
DASTDebuggerServiceTests >> testRemoveBreakpoint [
	| ds ast nodeBreak |
	ds := DASTDebuggerService new.
	ast := (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	ds initializeWithProgram: ast.
	
	nodeBreak := ast children first.
	ds addBreakPointAt: nodeBreak.
	self assert: (ds isBreakpoint: nodeBreak).
	
	ds removeBreakPointAt: nodeBreak.
	self assert: (ds isBreakpoint: nodeBreak) not
]
