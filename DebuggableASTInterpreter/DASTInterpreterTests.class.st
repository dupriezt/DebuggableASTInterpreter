Class {
	#name : #DASTInterpreterTests,
	#superclass : #TestCase,
	#category : #DebuggableASTInterpreter
}

{ #category : #tests }
DASTInterpreterTests >> testAddTwoNumbers [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').

	self assert: interpreter evaluate equals: 3
]

{ #category : #tests }
DASTInterpreterTests >> testAssignAndEvaluateTemporaryVariable [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x := 1 . x + 2').
	
	
	self assert: interpreter evaluate equals: 3
]

{ #category : #tests }
DASTInterpreterTests >> testAssignTemporaryVariableUsingItsOwnValue [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x := 1 . x := x + 2 . x').
	
	
	self assert: interpreter evaluate equals: 3
]

{ #category : #tests }
DASTInterpreterTests >> testAssignmentTemporaryVariable [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x := 1').
	
	
	self assert: interpreter evaluate equals: 1
]

{ #category : #tests }
DASTInterpreterTests >> testAssignmentTemporaryVariableTwice [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x := 1 . x := 2 . x').
	
	
	self assert: interpreter evaluate equals: 2
]

{ #category : #tests }
DASTInterpreterTests >> testBinaryMessageSendPushesReceiverAndArguments [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').

	self assert: interpreter evaluate equals: 3.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testBlockAssignedToVariableAndEvaluated [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '|b| b := [^ 3]. b value').
	value := interpreter evaluate.
	self assert: value equals: 3.
]

{ #category : #'tests-blocks-vars-local' }
DASTInterpreterTests >> testBlockAssignsOuterContextVariable [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: ' b := [ x:=1 ] . b value . x').
	value := interpreter evaluate.
	self assert: value equals: 2.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testBlockDeclaredInContextAndEvaluatedInAnotherContext [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '|x b| x:=1 . b := [^ x] . x:=2 . b value').
	value := interpreter evaluate.
	self assert: value equals: 2.
]

{ #category : #'tests-blocks-vars-local' }
DASTInterpreterTests >> testBlockVarsLocalDeclaredInsideBlock [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[|x| x:=1 ] value . x').
	value := interpreter evaluate.
	
	self assert: value equals: nil.
]

{ #category : #'tests-blocks-vars-local' }
DASTInterpreterTests >> testBlockVarsLocalDeclaredOutsideBlockAndModifiedInAnidatedBlock [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '|x| [ [ x:=1 ] value  ] value . x').
	value := interpreter evaluate.
	
	self assert: value equals: 1.
]

{ #category : #'tests-blocks-vars-local' }
DASTInterpreterTests >> testBlockVarsLocalDeclaredOutsideBlockAndModifiedInBlock [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '|x| [ x:=1 ] value . x').
	value := interpreter evaluate.
	
	self assert: value equals: 1.
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateConstant [

	| interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1').
	
	self assert: interpreter evaluate equals: 1
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateFullExpression [
	| interpreter |
	"evaluates the whole expression"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1 - 3 abs').
	self assert: interpreter evaluate equals: -2.
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateFullUnaryExpression [
	| interpreter |
	"evaluates the whole expression"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1').
	self assert: interpreter evaluate equals: 1.
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateMessageWithoutArguments [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1 abs').
	value := 1 abs.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-exceptions' }
DASTInterpreterTests >> testExceptionZeroDivide [
	<expectedFailure>
	| interpreter |
	
	
	
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1 / 0').
	"prevent that the exceptions are signaled"
	interpreter signalExceptions: false. 
	interpreter evaluate.
	self assert: interpreter exceptions isEmpty not.
	self assert: interpreter exceptions last asString equals: 'ZeroDivide'.
	

]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testFalse [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'false').
	
	value := false.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testIfTrue [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'true ifTrue: [^ 3]').
	value := interpreter evaluate.
	self assert: value equals: 3.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testIfTrueWithEvaluationAsReceiver [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '(1<2) ifTrue: [^ 3]').
	value := interpreter evaluate.
	self assert: value equals: 3.
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testInstantiateObject [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'Point basicNew').
	
	value := Point basicNew.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testInstantiateObjectAndInitializeVariables [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'Point x: 1 y: 2').
	
	value := Point x: 1 y: 2.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockDeclarationWithArguments [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '|x| x := 3 . ^ [ 1 ]').
	interpreter evaluate.
	value := interpreter stackTop.
	self assert: value asText equals: [ 1 ] asText.
	self assert: (value outerContext find: #x) equals: 3.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockDeclarationWithOuterContext [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '|x| x := 3 . ^ [ 1 ]').
	interpreter evaluate.
	value := interpreter stackTop.
	self assert: value asText equals: [ 1 ] asText.
	self assert: (value outerContext find: #x) equals: 3.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockDeclarationWithoutOuterContext [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[ 1 ]').
	interpreter evaluate.
	value := interpreter stackTop.
	self assert: value asText equals: [ 1 ] asText.
	self assert: value outerContext isEmpty.
]

{ #category : #'tests-blocks-vars-local' }
DASTInterpreterTests >> testInterpretBlockEvaluationThatModifiesOuterContext [

	| interpreter value blockValue |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '| x | x := 3 . [ x := 2 ] value . x').
	interpreter evaluate.
	value := interpreter stackTop.
	blockValue :=  [ | x | x := 3 . [ x := 2 ] value . x ] value.
	self assert: value equals: blockValue .
	
]

{ #category : #'tests-blocks-vars-local' }
DASTInterpreterTests >> testInterpretBlockEvaluationThatModifiesOuterContextTwice [

	| interpreter value blockValue |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '| x | x := 3 . [ x := 2 ] value . x:= 1 . x').
	interpreter evaluate.
	value := interpreter stackTop.
	blockValue :=  [ | x | x := 3 . [ x := 2 ] value . x:= 1 . x ] value.
	self assert: value equals: blockValue .
	
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockEvaluationWithArgumentsAndWithoutOuterContext [

	| interpreter value blockValue |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[ :x :y | x + y ] value: 1 value: 2 ').
	interpreter evaluate.
	value := interpreter stackTop.
	blockValue := [ :x :y | x + y ] value: 1 value: 2.
	self assert: value equals: blockValue.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockEvaluationWithoutArgumentsAndWithoutOuterContext [

	| interpreter value blockValue |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[ 1 ] value').
	interpreter evaluate.
	value := interpreter stackTop.
	blockValue := [ 1 ] value.
	self assert: value equals: blockValue.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretSendingMessageDifferentFromValueToBlock [

	| interpreter value blockValue |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '[ :x :y :z | 1 ] argumentCount').
	interpreter evaluate.
	value := interpreter stackTop.
	blockValue := [ :x :y :z | 1 ] argumentCount.
	self assert: value equals: blockValue.
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testLessThan [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1<2').
	
	value := 1<2.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-methods-local-vars' }
DASTInterpreterTests >> testLocalVariableAccessUndeclaredVariable [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'x').
	value := interpreter evaluate.
	self assert: interpreter exceptions isEmpty not.
	"self assert: interpreter exceptions last asString equals: 'ZeroDivide'."
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testLookupGlobalVariable [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'Point').
	
	value := Point.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testMoreThan [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1>2').
	
	value := 1>2.
	self assert: interpreter evaluate equals: value
]

{ #category : #tests }
DASTInterpreterTests >> testParenthesisForOperationAndUnaryMessage [

	| interpreter |
	"The unary message must be evaluated before the Add"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '(1 - 3) abs').
	self assert: interpreter evaluate equals: 2.
]

{ #category : #tests }
DASTInterpreterTests >> testPrecedenceForOperationAndMessageWithArgument [

	| interpreter |
	"The unary message must be evaluated before the Add"
	interpreter := DASTInterpreter new.

	interpreter initializeWithProgram: (RBParser parseExpression: '#abc at: 3 - 1').
	self assert: interpreter evaluate equals: $b.
]

{ #category : #tests }
DASTInterpreterTests >> testPrecedenceForOperationAndUnaryMessage [

	| interpreter |
	"The unary message must be evaluated before the Add"
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1 - 3 abs').
	self assert: interpreter evaluate equals: -2.
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testPrimitiveAdd [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1+2').
	
	value := 1+2.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testPrimitiveSubstract [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: '1-2').
	
	value := 1-2.
	self assert: interpreter evaluate equals: value
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testTrue [

	| interpreter value |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: (RBParser parseExpression: 'true').
	
	value := true.
	self assert: interpreter evaluate equals: value
]
