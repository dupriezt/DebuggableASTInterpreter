"
Experimental debugger for the DASTInterpreter, based on the spec debugger.

Code modificaiton from the debugger is not yet possible.
"
Class {
	#name : #DASTSpecDebugger,
	#superclass : #SpecDebugger,
	#category : #DebuggableASTDebugger
}

{ #category : #specs }
DASTSpecDebugger class >> defaultSpec [
	^ SpecLayout composed
		newColumn: [ :col | 
			col
				add: #stack;
				add: #toolbar height: self toolbarHeight.
			col
				addSplitter;
				add: #code;
				addSplitter;
				newRow: [ :row | 
					row
						add: #receiverInspector;
						add: #contextInspector ] ]
]

{ #category : #initialization }
DASTSpecDebugger >> initializeWidgets [
	stack := self instantiate: self stackPresenterClass.
	toolbar := self instantiate: SpecDebuggerDynamicToolbar.
	code := self newCode.
	receiverInspector := self instantiate: InspectorNavigator.
	contextInspector := self instantiate: DASTEyeContextInspector.
	self code
		acceptBlock: [ :text :notifyer | 
			self
				recompileMethodTo: text string
				inContext: self stack selectedItem
				notifying: notifyer ].
	self code whenBuiltDo: [ :ann | ann widget font: self codeFont ]
]

{ #category : #accessing }
DASTSpecDebugger >> stackPresenterClass [
	^DASTSpecDebuggerStack
]

{ #category : #updating }
DASTSpecDebugger >> updateCodeFromContext: aContext [
	| selectionInterval |
	selectionInterval := self session
		selectedCodeRangeForContext: aContext.
	self code
		aboutToStyle: true;
		text: aContext methodOrBlock source;
		doItReceiver: aContext receiver;
		doItContext: aContext;
		behavior: aContext receiver class;
		setSelection: selectionInterval;
		highlightNextIntructionInterval: selectionInterval
]

{ #category : #updating }
DASTSpecDebugger >> updateContextInspectorFromContext: aContext [
	| oldSelection newSelectionIndex   |
	
	oldSelection := contextInspector list selectedItem.
	
	contextInspector inspect: aContext.
	
	newSelectionIndex := 1.
	oldSelection ifNotNil: 
	[	contextInspector list listItems withIndexDo: 
			[ :item :index | item label = oldSelection label ifTrue: [ newSelectionIndex := index ] ].
	].
	contextInspector list setSelectedIndex: newSelectionIndex.
	
]

{ #category : #updating }
DASTSpecDebugger >> updateReceiverInspectorFromContext: aContext [
	| receiver oldSelection newSelectionIndex   |

	oldSelection := receiverInspector inspector ifNotNil: [ :inspector | inspector list selectedItem ].

	receiver := aContext ifNotNil: [ aContext receiver ]. 
	receiverInspector inspect: receiver.	
		
	newSelectionIndex := 1.
	oldSelection ifNotNil: 
	[	receiverInspector inspector list listItems withIndexDo: 
			[ :item :index | item label = oldSelection label ifTrue: [ newSelectionIndex := index ] ].
	].
	receiverInspector inspector list setSelectedIndex: newSelectionIndex.
	

]

{ #category : #'updating actions' }
DASTSpecDebugger >> updateStep [
	super updateStep.
	contextInspector generateElements 
]

{ #category : #updating }
DASTSpecDebugger >> updateToolbar [
	
	self toolbar update.
]

{ #category : #updating }
DASTSpecDebugger >> updateToolbarFromSession: aSession [

	self toolbar session: aSession.
]
