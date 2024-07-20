Class {
	#name : #DefendCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
DefendCard >> useWith: aCardManager target: aShipName [

	aCardManager applyDefendTo: aShipName
]
