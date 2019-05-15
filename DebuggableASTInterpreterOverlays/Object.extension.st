Extension { #name : #Object }

{ #category : #'*DebuggableASTInterpreterOverlays' }
Object >> allOverlayInspectorNodesOn: interpreter [
	"Answer a list of attributes as nodes"
	
	^ { StInspectorSelfNode hostObject: self }, 
		(self overlayinspectorNodesOn: interpreter)
]

{ #category : #'*DebuggableASTInterpreterOverlays' }
Object >> overlayInspection [
	"This is the most basic presentation showing the state of the object"
	^ StOverlayInspection owner: self on: self
]

{ #category : #'*DebuggableASTInterpreterOverlays' }
Object >> overlayInspectionWith: interpreter [
	"This is the most basic presentation showing the state of the object"
	^ StOverlayInspection interpreter: interpreter on: self 
]

{ #category : #'*DebuggableASTInterpreterOverlays' }
Object >> overlayinspectorNodesOn: interpreter [
	^ (StNodeCollector for: self) collectNodesUsing: interpreter
]
