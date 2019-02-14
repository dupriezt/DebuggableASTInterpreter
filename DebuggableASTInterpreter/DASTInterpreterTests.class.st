Class {
	#name : #DASTInterpreterTests,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #running }
DASTInterpreterTests >> evaluateProgram: aString [
	interpreter initializeWithProgram: (RBParser parseExpression: aString).
	^ interpreter evaluate
]

{ #category : #running }
DASTInterpreterTests >> setUp [
	interpreter := DASTInterpreter new.
]

{ #category : #tests }
DASTInterpreterTests >> testAddTwoNumbers [

	self assert: (self evaluateProgram: '^1+2' ) 
		  equals: 3
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testBlockAssignedToVariableAndEvaluated [

	self assert: (self evaluateProgram: '|b| b := [^ 3]. b value' ) 
		  equals: 3
	
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testBlockEvaluated [

	self assert: (self evaluateProgram: '[^ 3] value' ) 
		  equals: 3
	
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testBlockThatReturns32EvaluatedInThisContext [

	self assert: (self evaluateProgram: 'DASTInterpreterClassForTests getBlockThatReturns32EvaluatedInThisContext' ) 
		  equals: 32	
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateConstant [

	self assert: (self evaluateProgram: '1' ) 
		  equals: 1
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateFullExpression [
	
	self assert: (self evaluateProgram: '1 - 3 abs' ) 
		  equals: -2
]

{ #category : #tests }
DASTInterpreterTests >> testEvaluateMessageWithoutArguments [

	self assert: (self evaluateProgram: '^1 abs' ) 
		  equals: 1
]

{ #category : #'tests-exceptions' }
DASTInterpreterTests >> testExceptionZeroDivide [
	<expectedFailure>
	| anInterpreter |
	
	
	
	anInterpreter := DASTInterpreter new.
	anInterpreter initializeWithProgram: (RBParser parseExpression: '1 / 0').
	"prevent that the exceptions are signaled"
	anInterpreter signalExceptions: false. 
	anInterpreter evaluate.
	self assert: anInterpreter exceptions isEmpty not.
	self assert: anInterpreter exceptions last asString equals: 'ZeroDivide'.
	

]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testFalse [
	self assert: (self evaluateProgram: 'false')
		  equals: false
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testIfTrue [

	self assert: (self evaluateProgram: '^true ifTrue: [3]' ) 
		  equals: 3
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testIfTrueWithEvaluationAsReceiver [

	self assert: (self evaluateProgram: '^ 1<2 ifTrue: [3]' ) 
		  equals: 3
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testInstantiateObject [

	self assert: (self evaluateProgram: '^Point basicNew') 
		  equals: (Point basicNew)
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testInstantiateObjectAndSetInstanceVariables [

	self assert: (self evaluateProgram: '^ Point x: 1 y: 2') 
		  equals: (Point x: 1 y: 2)
	
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testInstantiateObjectAndSetInstanceVariablesAndGetInstanceVariables [

	self assert: (self evaluateProgram: '|p| p:= Point x: 1 y: 2 .^ p x') 
		  equals: 1

]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockCreatedInDifferentContext [

	self assert: (self evaluateProgram: '^DASTInterpreterClassForTests getBlockThatEvaluatesConstant42 value')
		  equals:42.

]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockDeclarationWithOuterContext [

	| anInterpreter value |
	anInterpreter := DASTInterpreter new.
	anInterpreter initializeWithProgram: (RBParser parseExpression: '|x| x := 3 . ^ [ 1 ]').
	anInterpreter evaluate.
	value := anInterpreter stackTop.
	self assert: value asText equals: [ 1 ] asText.
	self assert: (value outerContext find: #x) equals: 3.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockDeclarationWithoutOuterContext [

	| anInterpreter value |
	anInterpreter := DASTInterpreter new.
	anInterpreter initializeWithProgram: (RBParser parseExpression: '[ 1 ]').
	anInterpreter evaluate.
	value := anInterpreter stackTop.
	self assert: value asText equals: [ 1 ] asText.
	self assert: value outerContext isEmpty.
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockEvaluationWithArgumentsAndWithoutOuterContext [

	self assert: (self evaluateProgram: '^ [ :x :y | x + y ] value: 1 value: 2')
		  equals:3.

]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockEvaluationWithOneArgumentAndWithoutOuterContext [

	self assert: (self evaluateProgram: '^ [ :x | x ] value: 2')
		  equals:2

]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretBlockEvaluationWithoutArgumentsAndWithoutOuterContext [

	self assert: (self evaluateProgram: '^ [ 1 ] value')
		  equals:1
]

{ #category : #'tests-blocks' }
DASTInterpreterTests >> testInterpretSendingMessageDifferentFromValueToBlock [
	
	self assert: (self evaluateProgram: '^ [ :x :y :z | 1 ] argumentCount')
		  equals: 3
	
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testLessThan [

	self assert: (self evaluateProgram: '^ 1<2')
		  equals: true
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarAccessedForUpdatingItsOwnValue [

	self assert: (self evaluateProgram: '|x| x := 1 . x := x + 2 .  x' ) 
		  equals: 3
		

]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarAsArgumentInMessage [

	self assert: (self evaluateProgram: '|x| x := 1 . ^ 2 + x' ) 
		  equals: 3
		
	
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarAsReceiverInMessage [

	self assert: (self evaluateProgram: '|x| x := 1 . ^ x + 2' ) 
		  equals: 3
		
	
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarAssignationAndEvaluation [
	
	self assert: (self evaluateProgram: '|x| x := 1. ^ x' ) 
		  equals: 1
		
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarLastAssignationPrevails [

	self assert: (self evaluateProgram: '|x| x := 1 . x := 2 . ^ x ') 
		  equals: 2
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarScopeWhenAccessedFromABlockCreatedInADifferentContext [
	
	self assert: (self evaluateProgram: '^ DASTInterpreterClassForTests getBlockThatAccessesVariableTSetAs42 value' ) 
		  equals: 42
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarScopeWhenAccessedFromBlock [

	self assert: (self evaluateProgram:  '|x b| x:=1 . b := [^ x] . x:=2 . ^b value' ) 
		  equals: 2
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarScopeWhenAccessedFromBlockAnidated [

	self assert: (self evaluateProgram:  '|x b| x:=1 . b := [[^ x]] . x:=2 . ^b value value' ) 
		  equals: 2
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarScopeWhenModifiedFromBlock [

	self assert: (self evaluateProgram:  '|x| [[ x:=1 ]] value value . ^ x ') 
		  equals: 1
	
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testLocalVarScopeWhenModifiedFromBlockAnidated [

	self assert: (self evaluateProgram:  '|x| [[ x:=1 ]] value value . ^ x ') 
		  equals: 1
	
]

{ #category : #'tests-contexts' }
DASTInterpreterTests >> testLookupGlobalVariable [

	self assert: (self evaluateProgram: '^ Point') 
		  equals: Point
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testMoreThan [

	self assert: (self evaluateProgram: '1>2')
		  equals: false
]

{ #category : #tests }
DASTInterpreterTests >> testParenthesisForOperationAndUnaryMessage [

	self assert: (self evaluateProgram: '(1 -  3) abs')
	   equals: 2.
]

{ #category : #tests }
DASTInterpreterTests >> testPrecedenceForOperationAndMessageWithArgument [
	
	self assert: (self evaluateProgram: '^ #abc at: 3 - 1')
	   equals: $b
]

{ #category : #tests }
DASTInterpreterTests >> testPrecedenceForOperationAndUnaryMessage [
	
	self assert: (self evaluateProgram: '^ 1 - 3 abs')
	   equals: -2
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testPrimitiveAdd [

	self assert: (self evaluateProgram: '^ 1+2')
		  equals: 3
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testPrimitiveSubstract [

	self assert: (self evaluateProgram: '^ 1-2')
		  equals: -1
]

{ #category : #'tests-primitives' }
DASTInterpreterTests >> testTrue [

	self assert: (self evaluateProgram: '^ true')
		  equals: true
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testVarsLocalBlockAssignsHomeContextLocalVariable [
	
	self assert: (self evaluateProgram:  '|b x| b := [ x:=1 ] . b value . ^ x') 
		  equals: 1
		
]

{ #category : #'tests-variables-local' }
DASTInterpreterTests >> testVarsLocalBlockDeclaredOutsideBlockAndModifiedInAnidatedBlock [

	self assert: (self evaluateProgram:  '|x| [ [ x:=1 ] value  ] value . ^ x') 
		  equals: 1
	
]
