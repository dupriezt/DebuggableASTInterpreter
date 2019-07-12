Extension { #name : #RGBehavior }

{ #category : #'*DebuggableASTInterpreter' }
RGBehavior >> lookupSelector: selector installingMissingClassesWithClassLoader: aPBSpurClassLoaderCandle [ 
	| lookupClass |
	lookupClass := self.
	
	[lookupClass == nil]
		whileFalse: [ 			
			lookupClass methodDict 
				at: selector
				ifPresent: [ :method | ^ method ].
			lookupClass := lookupClass superclass].
	^ nil
]
