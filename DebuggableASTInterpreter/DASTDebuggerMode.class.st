"
I define in which way the interpreter excecution is handled every time a node is evaluated
"
Class {
	#name : #DASTDebuggerMode,
	#superclass : #Object,
	#instVars : [
		'debuggerService',
		'mode'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #running }
DASTDebuggerMode >> debuggerService: aDASTDebuggerService [
	debuggerService := aDASTDebuggerService
]

{ #category : #running }
DASTDebuggerMode >> onTracePoint: aRBNode [
	debuggerService tracepointReachedFor: aRBNode
]
