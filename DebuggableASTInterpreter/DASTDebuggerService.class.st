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

{ #category : #private }
DASTDebuggerService >> canBeTracePoint: aRBNode [
	^ 
	{ RBBlockNode 
		-> (aRBNode parent isSequence) not. "a block node declaration (without evaluation) inside a sequence, cannot be a tracepoint"
	  RBLiteralValueNode -> false. "literal nodes are not traced"
	  RBAssignmentNode -> true.
	  RBMessageNode -> true.
	  RBSequenceNode -> false.
	  RBVariableNode 
		-> (aRBNode parent isAssignment 
			and: [ aRBNode parent children last = aRBNode ]) not . "variable name to the left of an assignation are not traced" 
	} asDictionary
	at: aRBNode class
]

{ #category : #accessing }
DASTDebuggerService >> currentNode [
	^interpreter currentNode
]

{ #category : #initialization }
DASTDebuggerService >> initializeWithProgram: aRBNode [ 

	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram: aRBNode; debuggerService: self.
	mode := DASTDebuggerModeContinue new debuggerService: self.
]

{ #category : #'accessing - private' }
DASTDebuggerService >> interpreter [
	^ interpreter
]

{ #category : #initialization }
DASTDebuggerService >> isBreakpoint: aRBNode [
	^ self breakpoints contains: [:bp | bp = aRBNode ]
]

{ #category : #accessing }
DASTDebuggerService >> mode [
	^ mode
]

{ #category : #accessing }
DASTDebuggerService >> mode: aDASTDebuggerMode [ 
	mode := aDASTDebuggerMode
]

{ #category : #running }
DASTDebuggerService >> onTracePoint: aRBNode [
	(self canBeTracePoint: aRBNode) 
		ifTrue: [ mode onTracePoint: aRBNode ]
	
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
	Transcript show: 'Tracepoint reached in '; show: aRBNode asString; cr;cr.
	interpreter suspendProcess
]
