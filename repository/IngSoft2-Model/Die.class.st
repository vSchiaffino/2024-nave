Class {
	#name : #Die,
	#superclass : #Object,
	#instVars : [
		'faces'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Die class >> of: anAmountOfFaces [

	self verifyAreValid: anAmountOfFaces.
	^ self new initializeWith: anAmountOfFaces
]

{ #category : #'helper methods' }
Die class >> verifyAreValid: anAmountOfFaces [

	anAmountOfFaces <= 2 ifTrue: [
		Error signal: 'number of faces must be greater than two' ]
]

{ #category : #initialization }
Die >> initializeWith: anAmountOfFaces [

	faces := anAmountOfFaces
]

{ #category : #'dice logic' }
Die >> throw [

	^ faces atRandom
]
