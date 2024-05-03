Class {
	#name : #LoadedDie,
	#superclass : #Object,
	#instVars : [
		'loadedFace'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #evaluating }
LoadedDie class >> in: loadedFace [
	^ (self new) initializeWith: loadedFace.
]

{ #category : #initialization }
LoadedDie >> initializeWith: aLoadedFace [ 
	loadedFace := aLoadedFace
]

{ #category : #'as yet unclassified' }
LoadedDie >> throw [
	^loadedFace.
]
