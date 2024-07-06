Class {
	#name : #CardEffect,
	#superclass : #Object,
	#instVars : [
		'createdBy'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
CardEffect >> diceModifierTo: aShipName [

	^ 0
]

{ #category : #'helper methods' }
CardEffect >> is: actualShip alliedWith: collidingShip [

	^ false
]

{ #category : #'helper methods' }
CardEffect >> is: aShip mercenaryOf: anotherShip [

	^ false
]

{ #category : #'helper methods' }
CardEffect >> mercenaryCollideWith: possibleMercenaryName [

	^ false
]

{ #category : #'helper methods' }
CardEffect >> wasCreatedBy: aCard [

	^ aCard = createdBy
]
