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

{ #category : #'tests-mode-continue' }
DASTDebuggerServiceTests >> testInterpretAllWithoutBreakPoints [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: (RBParser parseExpression: '1').
	
	ds runInterpreter.
	
	self assert: ds returnedValue equals: 1.
	
]

{ #category : #'tests-mode-continue' }
DASTDebuggerServiceTests >> testInterpretComplexMessageAllWithoutBreakPoint [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	self assert: ds mode = DASTDebuggerModeContinue.
	ds runInterpreter.
	ds assert: ds interpreter process isTerminated.
	self assert: ds returnedValue equals: 3 
	
]

{ #category : #'tests-interpreter-process-state' }
DASTDebuggerServiceTests >> testInterpreterIsInTheRightNodeWhenReachingABreakpoint [
	| ds ast break |
	ds := DASTDebuggerService new.
	
	ast := (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	ds initializeWithProgram: ast .
	break := ast children second.
	ds addBreakPointAt: break.
	ds runInterpreter.
	self assert: ds currentNode equals: break.
	
]

{ #category : #'tests-interpreter-process-state' }
DASTDebuggerServiceTests >> testInterpreterProcessIsSuspendedWhenReachingBreakpoint [
	| ds ast break |
	ds := DASTDebuggerService new.
	
	ast := (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	ds initializeWithProgram: ast .
	break := ast children second children first.
	ds addBreakPointAt: break.
	ds runInterpreter.
	self assert: ds interpreter currentNode equals: break.
	
]

{ #category : #'tests-interpreter-process-state' }
DASTDebuggerServiceTests >> testInterpreterProcessIsTerminatedAfterFullEvaluation [
	| ds |
	ds := DASTDebuggerService new.
	ds initializeWithProgram: (RBParser parseExpression: 'x:=1 . x:= x+2 . x').

	ds runInterpreter.
	self assert: ds interpreter process isTerminated 
	
]

{ #category : #'tests-interpreter-process-state' }
DASTDebuggerServiceTests >> testInterpreterProcessIsTerminatedWhenRunningAfterReachingABreakpoint [
	| ds ast |
	ds := DASTDebuggerService new.
	
	ast := (RBParser parseExpression: 'x:=1 . x:= x+2 . x').
	ds initializeWithProgram: ast .
	ds addBreakPointAt: ast children second.
	ds runInterpreter.
	
	ds runInterpreter.
	self assert: ds interpreter process isTerminated.
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
