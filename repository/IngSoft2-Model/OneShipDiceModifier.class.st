Class {
	#name : #OneShipDiceModifier,
	#superclass : #CardEffect,
	#instVars : [
		'targetShipName'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
OneShipDiceModifier class >> to: aTargetShipName  createdBy: aCard [

	^ self new initializeWith: aTargetShipName createdBy: aCard
]

{ #category : #'card effect' }
OneShipDiceModifier >> diceModifierTo: aShipName [

	^ targetShipName = aShipName
		  ifTrue: [ 1 ]
		  ifFalse: [ 0 ]
]

{ #category : #initialization }
OneShipDiceModifier >> initializeWith: aTargetShipName createdBy: aCard [

	targetShipName := aTargetShipName.
	createdBy := aCard.
	^ self
]
