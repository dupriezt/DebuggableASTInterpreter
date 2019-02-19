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
	
	self assert: ds currentNode equals: (RBParser parseExpression:'1')	
	
]

{ #category : #tests }
DASTDebuggerInterpreterTests >> testStepInto [
	interpreter initializeWithProgram: (RBParser parseExpression: '1 + 2').
	self assert: interpreter stepInto equals: 1.
	self assert: interpreter stepInto equals: 2.
	
]
