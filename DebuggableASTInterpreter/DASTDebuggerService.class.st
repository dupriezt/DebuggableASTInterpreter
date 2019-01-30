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

{ #category : #accessing }
DASTDebuggerService >> currentNode [
	^interpreter currentNode
]

{ #category : #initialization }
DASTDebuggerService >> initializeWithProgram: aString [ 
	| aRBNode |
	aRBNode := RBParser parseExpression: aString.
	
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: aRBNode debuggerService: self.
	mode := DASTDebuggerModeContinue new debuggerService: self.
	self addBreakPointAt: interpreter currentNode.
]

{ #category : #running }
DASTDebuggerService >> onTracePoint: aRBNode [
	mode onTracePoint: aRBNode
]

{ #category : #running }
DASTDebuggerService >> runInterpreter [
	^ interpreter run
]

{ #category : #running }
DASTDebuggerService >> tracepointReachedFor: aRBNode [
	
	[interpreter process suspend] fork
]
