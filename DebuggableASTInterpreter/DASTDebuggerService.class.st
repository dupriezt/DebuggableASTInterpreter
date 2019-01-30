"
I handle the excecution flow of the debugging.
I contain an interpreter and control its excecution
"
Class {
	#name : #DASTDebuggerService,
	#superclass : #Object,
	#instVars : [
		'mode',
		'breakpoints',
		'interpreter'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #breakpoints }
DASTDebuggerService >> addBreakPointAt: aRBNode [ 
	breakpoints ifNil: [ 
		breakpoints := OrderedCollection new ].
	breakpoints add: aRBNode.
]

{ #category : #initialization }
DASTDebuggerService >> initializeWithProgram: aString [ 
	| aRBNode |
	aRBNode := RBParser parseExpression: aString.
	
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: aRBNode.
	mode := DASTDebuggerModeContinue new.
	self addBreakPointAt: interpreter currentNode.
]

{ #category : #running }
DASTDebuggerService >> runInterpreter [
	^ interpreter evaluate
]