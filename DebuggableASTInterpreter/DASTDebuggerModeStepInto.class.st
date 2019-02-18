"
I determine that the interpreter stops evaluation every time the onTracePoint message is sent
"
Class {
	#name : #DASTDebuggerModeStepInto,
	#superclass : #DASTDebuggerMode,
	#category : #DebuggableASTInterpreter
}

{ #category : #running }
DASTDebuggerModeStepInto >> onTracePoint: aRBNode [
	debuggerService tracepointReachedFor: aRBNode.
	^ true
]

{ #category : #running }
DASTDebuggerModeStepInto >> stepInto [
	debuggerService runInterpreter 
]
