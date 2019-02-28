Class {
	#name : #DASTDebuggerInterpreterTests,
	#superclass : #DASTAbstractInterpreterTests,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTDebuggerInterpreterTests >> testFirstNodeToEvaluateInASum [
	interpreter initializeWithProgram: (RBParser parseExpression: '1 + 1').
	
	self assert: interpreter currentNode equals: (RBParser parseExpression:'1')	
	
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepAfterTheEndOfProgramExcecutionThrowsAnException [
	interpreter initializeWithProgram: (RBParser parseExpression: '1').
	self assert: interpreter stepOver equals: 1.
	self should: [interpreter stepOver] raise: DASTEvaluationTerminated 
	
	
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepInto [
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').
	self assert: interpreter stepInto equals: 1.
	self assert: interpreter stepInto equals: 2.
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepIntoBlock [
	interpreter initializeWithProgram: (RBParser parseExpression: '[1+3] value').
	self assert: interpreter stepInto class equals: DASTBlock .
	self assert: interpreter stepInto equals: nil.
	self assert: interpreter stepInto equals: 1.
	self assert: interpreter stepInto equals: 3.
	self assert: interpreter stepInto equals: 4.
	self assert: interpreter stepInto equals: 4.
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepIntoMethod [
	interpreter initializeWithProgram: (RBParser parseExpression: '2 raisedTo: 3').
	self assert: interpreter stepInto equals: 2.
	self assert: interpreter stepInto equals: 3.
	self assert: interpreter stepInto equals: nil.
	self assert: interpreter stepInto equals: 3.
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepOver [
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').
	self assert: (interpreter stepOver; stackTop) equals: 1.
	self assert: (interpreter stepOver; stackTop) equals: 2.
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepOverBlock [
	interpreter initializeWithProgram: (RBParser parseExpression: '[1+3] value').
	self assert: interpreter stepOver class equals: DASTBlock .
	self assert: interpreter stepOver equals: 4.
	
	
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepOverMethod [
	interpreter initializeWithProgram: (RBParser parseExpression: '2 raisedTo: 3').
	self assert: interpreter stepOver equals: 2.
	self assert: interpreter stepOver equals: 3.
	self assert: interpreter stepOver equals: 8.
	
	
]
