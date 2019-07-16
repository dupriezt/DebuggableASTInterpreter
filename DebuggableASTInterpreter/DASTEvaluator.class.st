Class {
	#name : #DASTEvaluator,
	#superclass : #EPASTEvaluator,
	#instVars : [
		'interpreter'
	],
	#category : #'DebuggableASTInterpreter-Espell'
}

{ #category : #interpreting }
DASTEvaluator >> evaluateAST: ast [
	
	^ self evaluateAST: ast withTemps: #() 
]

{ #category : #interpreting }
DASTEvaluator >> evaluateCode: someCode withTemps: aCollectionOfTemps [
	self flag: 'move the parser to a method that compiles it'.
	^self evaluateAST: (RBParser parseExpression: someCode) withTemps: aCollectionOfTemps 
]

{ #category : #interpreting }
DASTEvaluator >> initialize [

	super initialize.
	interpreterClass := DASTInterpreter.
	
]

{ #category : #accessing }
DASTEvaluator >> interpreter [
	^ interpreter ifNil: [ self newInterpreter ]
]

{ #category : #accessing }
DASTEvaluator >> newInterpreter [
	^ interpreter := super newInterpreter
	
]
