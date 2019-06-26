Class {
	#name : #DASTEvaluator,
	#superclass : #EPASTEvaluator,
	#category : #'DebuggableASTInterpreter-Espell'
}

{ #category : #interpreting }
DASTEvaluator >> evaluateAST: ast [
	
	^ self evaluateAST: ast withTemps: #() 
]

{ #category : #interpreting }
DASTEvaluator >> initialize [

	super initialize.
	interpreterClass := DASTInterpreter.
	
]
