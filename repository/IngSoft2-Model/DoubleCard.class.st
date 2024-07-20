Class {
	#name : #DoubleCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
DoubleCard >> useWith: aCardManager target: aShipName [

	aCardManager doubleBattleModifierTo: aShipName.
	aCardManager discard: self
]
