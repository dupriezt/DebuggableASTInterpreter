"
I determine that the interpreter does not follow recursion and method calls. I have a context variable for saving the node (context) that was evaluated when this mode activated
"
Class {
	#name : #DASTDebuggerModeStepOver,
	#superclass : #DASTDebuggerMode,
	#instVars : [
		'context'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #'debugging actions' }
DASTDebuggerModeStepOver >> onTracePoint: aRBNode [
	(context = debuggerService currentNode) ifTrue: [ 
		debuggerService tracepointReachedFor: aRBNode	.
		^ true
		 ].
	^ false

]

{ #category : #'debugging actions' }
DASTDebuggerModeStepOver >> stepOver [
	context := debuggerService currentNode.
	debuggerService runInterpreter 
]
