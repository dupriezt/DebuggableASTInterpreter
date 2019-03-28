"
Reimplementation of the spec debugger stack for debugging model compatibility. Should not exist if debugging model APIs were unified.
"
Class {
	#name : #DASTSpecDebuggerStack,
	#superclass : #SpecDebuggerStack,
	#category : #DebuggableASTDebugger
}

{ #category : #printing }
DASTSpecDebuggerStack >> columnsFor: context [
	"protocol: printing"

	"Answer the array of contexts."

	| method classLocation receiverClass |
	method := context methodOrBlock.
	classLocation := method methodClass.
	receiverClass := context receiver class.

	"If the receiver is differen from the implementor, show the original method implementor"
	classLocation := classLocation = receiverClass
		ifTrue: [ classLocation name ]
		ifFalse: [ receiverClass name , '(' , classLocation name , ')' ].
	context isBlockContext
		ifTrue: [ classLocation := '[...] in ' , classLocation ].
	^ {classLocation.
	method selector asString}
]
