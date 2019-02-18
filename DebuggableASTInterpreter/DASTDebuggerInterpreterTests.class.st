Class {
	#name : #DASTDebuggerInterpreterTests,
	#superclass : #DASTAbstractInterpreterTests,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTDebuggerInterpreterTests >> testFirstNodeToEvaluateInASum [
	| ds ast |

	ds := DASTDebuggerService new.
	ast := (RBParser parseExpression: '^ 1 + 2').
	ds initializeWithProgram: ast.
	
	self assert: ds currentNode equals: ast	
	
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepInto [
	| ds ast |
	self skip.
	ds := DASTDebuggerService new.
	ast := (RBParser parseExpression: '1 + 1').
	ds initializeWithProgram: ast.
	ds stepInto
	
]
