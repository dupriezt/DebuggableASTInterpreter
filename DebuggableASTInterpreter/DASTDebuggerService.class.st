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
	self breakpoints add: aRBNode.
]

{ #category : #accessing }
DASTDebuggerService >> breakpoints [
	^ breakpoints ifNil: [ 
		breakpoints := OrderedCollection new ].
]

{ #category : #accessing }
DASTDebuggerService >> currentNode [
	^interpreter currentNode
]

{ #category : #initialization }
DASTDebuggerService >> initializeWithProgram: aRBNode [ 

	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: aRBNode debuggerService: self.
	mode := DASTDebuggerModeStepInto new debuggerService: self.
]

{ #category : #'accessing - private' }
DASTDebuggerService >> interpreter [
	^ interpreter
]

{ #category : #initialization }
DASTDebuggerService >> isBreakpoint: aRBNode [
	^ breakpoints contains: [:bp | bp = aRBNode ]
]

{ #category : #running }
DASTDebuggerService >> onTracePoint: aRBNode [
	mode onTracePoint: aRBNode
]

{ #category : #breakpoints }
DASTDebuggerService >> removeAllBreakPoints [
	self breakpoints removeAll
]

{ #category : #breakpoints }
DASTDebuggerService >> removeBreakPointAt: aRBNode [ 
	self breakpoints remove: aRBNode 
]

{ #category : #running }
DASTDebuggerService >> returnedValue [
	^ interpreter stackTop
]

{ #category : #running }
DASTDebuggerService >> runInterpreter [
	^ interpreter run
]

{ #category : #running }
DASTDebuggerService >> tracepointReachedFor: aRBNode [
	
	[interpreter process suspend] fork
]
