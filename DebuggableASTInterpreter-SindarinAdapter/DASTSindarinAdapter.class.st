Class {
	#name : #DASTSindarinAdapter,
	#superclass : #SindarinAdapter,
	#instVars : [
		'dastInterpreter'
	],
	#category : #'DebuggableASTInterpreter-SindarinAdapter'
}

{ #category : #accessing }
DASTSindarinAdapter >> context [
	"() -> (SindarinContext)
	Current context of the execution"
	^ dastInterpreter currentContext
]

{ #category : #start }
DASTSindarinAdapter >> debug: aBlock [
	"(BlockClosure) -> (DebugSession)
	Initialise self (newly created instance) to be a debug session on the execution of the provided block closure. Return self."
	dastInterpreter := DASTInterpreter new.
	dastInterpreter initializeWithProgram: (RBParser parseExpression: aBlock sourceNode sourceCode, ' value').
	dastInterpreter stepOver; stepInto. "dastInterpreter was initialised on '[<interestingCode>] value', so stepping over the block node and then stepping into the #value message send will set the dastInterpreter directly on the execution of <interestingCode>"
	^ self.
]

{ #category : #accessing }
DASTSindarinAdapter >> isTerminated [
	"() -> (Boolean)
	Returns whether the debuged execution is finished."
	^ dastInterpreter isTerminated
]

{ #category : #stepping }
DASTSindarinAdapter >> step [
	"() -> ()
	Steps the execution once. This is the smallest step the debugged execution can make.
	This must signal an exception if the execution signalled an exception that it did not handle. The former exception must contain the latter."
	dastInterpreter stepInto
]
