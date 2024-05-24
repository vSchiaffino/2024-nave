Class {
	#name : #Die,
	#superclass : #Object,
	#instVars : [
		'faces'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Die class >> of: anAmountOfFaces [

	self verifyAreValid: anAmountOfFaces.
	^ self new initializeWith: anAmountOfFaces
]

{ #category : #'instance creation' }
Die class >> verifyAreValid: anAmountOfFaces [

	anAmountOfFaces <= 2 ifTrue: [
		Error signal: 'number of faces must be greater than two' ]
]

{ #category : #'as yet unclassified' }
Die >> initializeWith: anAmountOfFaces [

	faces := anAmountOfFaces
]

{ #category : #'as yet unclassified' }
Die >> throw [

	^ faces atRandom
]
