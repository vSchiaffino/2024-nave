Class {
	#name : #SpeedCard,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
SpeedCard >> diceModifierTo: aShipName [

	aShipName ~= targetShipName ifTrue: [ ^ 0 ].
	^ 1
]

{ #category : #'as yet unclassified' }
SpeedCard >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	someActiveCards add: self
]
