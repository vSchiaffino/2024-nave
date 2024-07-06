Class {
	#name : #AllShipsDiceModifier,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
AllShipsDiceModifier class >> createdBy: aCard [

	^ self new initializeWith: aCard
]

{ #category : #'card effect' }
AllShipsDiceModifier >> diceModifierTo: aShipName [

	^ 1
]

{ #category : #initialization }
AllShipsDiceModifier >> initializeWith: aCard [

	createdBy := aCard.
	^ self
]
