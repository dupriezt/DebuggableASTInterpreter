"
I determine that the interpreter continues evaluation until reaching a breakpoint
"
Class {
	#name : #DASTDebuggerModeContinue,
	#superclass : #DASTDebuggerMode,
	#category : #DebuggableASTInterpreter
}

{ #category : #running }
DASTDebuggerModeContinue >> continue [
	debuggerService runInterpreter 
]

{ #category : #running }
DASTDebuggerModeContinue >> onTracePoint: aRBNode [
	(debuggerService isBreakpoint: aRBNode) ifTrue: [  
		debuggerService tracepointReachedFor: aRBNode
		].
	
	
]
