Class {
	#name : #CardGivingCell,
	#superclass : #Cell,
	#instVars : [
		'deck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
CardGivingCell class >> deck: aDeck [

	^ super new initializeWith: aDeck
]

{ #category : #'cell effect' }
CardGivingCell >> applyEffectTo: aShip in: aBoard [

	deck dealTo: aShip
]

{ #category : #initialization }
CardGivingCell >> initializeWith: aDeck [

	ships := OrderedCollection new.
	deck := aDeck.
	^ self
]
