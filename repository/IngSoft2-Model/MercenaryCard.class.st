Class {
	#name : #MercenaryCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
MercenaryCard >> useWith: aCardManager target: aTargetShipName [

	aCardManager verifyIsCardPlayerTurn.
	aCardManager verifyMercenaryCollision: aTargetShipName.
	aCardManager
		assignMercenaryShipToCardPlayer: aTargetShipName
		by: self
]
