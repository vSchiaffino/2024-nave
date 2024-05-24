Class {
	#name : #LoadedDie,
	#superclass : #Object,
	#instVars : [
		'sequence'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
LoadedDie class >> sequence: aSequenceOfNumbers [
	^ (self new) initializeWith: aSequenceOfNumbers
]

{ #category : #initialization }
LoadedDie >> initializeWith: aSequenceOfNumbers [

	sequence := aSequenceOfNumbers.
	^ self
]

{ #category : #'as yet unclassified' }
LoadedDie >> throw [

	| dieResult |
	dieResult := sequence removeFirst.
	sequence addLast: dieResult.
	^ dieResult
]
