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
