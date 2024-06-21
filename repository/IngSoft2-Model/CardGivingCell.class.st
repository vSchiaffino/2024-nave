Class {
	#name : #CardGivingCell,
	#superclass : #Cell,
	#instVars : [
		'deck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
CardGivingCell class >> deck: aDeck [

	^ super new initializeWith: aDeck
]

{ #category : #'instance creation' }
CardGivingCell class >> new [

	^ self deck: Deck new
]

{ #category : #'as yet unclassified' }
CardGivingCell >> applyEffectTo: aShip in: aBoard [

	aShip receive: deck drawCard
]

{ #category : #initialization }
CardGivingCell >> initializeWith: aDeck [

	ships := OrderedCollection new.
	deck := aDeck.
	^ self
]
