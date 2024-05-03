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
	self verifyGreaterThanTwo: anAmountOfFaces.
	^ self new initializeWith: anAmountOfFaces
]

{ #category : #'instance creation' }
Die class >> verifyGreaterThanTwo: anAmountOfFaces [

	anAmountOfFaces <= 2 ifTrue: [
		Error signal: 'number of faces must be greater than two' ]
]

{ #category : #'as yet unclassified' }
Die >> initializeWith: anAmountOfFaces [
	faces := anAmountOfFaces
]

{ #category : #'as yet unclassified' }
Die >> throw [
	^ faces atRandom.
]
