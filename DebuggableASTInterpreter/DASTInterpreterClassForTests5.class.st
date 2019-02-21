Class {
	#name : #DASTInterpreterClassForTests5,
	#superclass : #Object,
	#classInstVars : [
		'count'
	],
	#category : #DebuggableASTInterpreter
}

{ #category : #'class initialization' }
DASTInterpreterClassForTests5 class >> count [
	^ count
]

{ #category : #'class initialization' }
DASTInterpreterClassForTests5 class >> initialize [ 
	count := 0
]

{ #category : #'class initialization' }
DASTInterpreterClassForTests5 class >> new [
    count := count +1.
    ^ super new
]
