Class {
	#name : #AccelerationCard,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
AccelerationCard >> diceModifierTo: aShipName [

	^ 1
]

{ #category : #'as yet unclassified' }
AccelerationCard >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	someActiveCards add: self
]
