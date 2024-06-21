Class {
	#name : #LoadedDeck,
	#superclass : #Object,
	#instVars : [
		'cardsToDraw'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
LoadedDeck class >> cards: someCardsToDraw [

	^ self new initializeWith: someCardsToDraw
]

{ #category : #drawing }
LoadedDeck >> drawCard [

	| drawedCard |
	drawedCard := cardsToDraw removeFirst.
	cardsToDraw addLast: drawedCard.
	^ drawedCard
]

{ #category : #initialization }
LoadedDeck >> initializeWith: someCardsToDraw [

	cardsToDraw := someCardsToDraw
]
