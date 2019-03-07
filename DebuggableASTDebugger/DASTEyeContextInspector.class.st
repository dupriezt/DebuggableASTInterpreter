"
Reimplementation of the spec context inspector for debugging model compatibility. Should not exist if debugging model APIs were unified. 

Also that current form might disappear or change with SPEC 2.
"
Class {
	#name : #DASTEyeContextInspector,
	#superclass : #EyeDebuggerContextInspector,
	#category : #DebuggableASTDebugger
}

{ #category : #list }
DASTEyeContextInspector >> addSpecialFields: elements [
	self object variablesDict
		keysAndValuesDo: [ :name :value | 
			elements
				add: (DynamicEyeElement host: self object label: name value: value) ]
]

{ #category : #list }
DASTEyeContextInspector >> addStackTop: elements [

	elements
		add:
			(DynamicEyeElement
				host: self object
				label: 'stackTop'
				value: [self object top])
]
