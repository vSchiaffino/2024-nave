Class {
	#name : #SpeedCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
SpeedCard >> useWith: aCardManager target: aTargetShip [

	aCardManager verifyIsCardPlayerTurn.
	aCardManager addCardEffect:
		(OneShipDiceModifier to: aTargetShip createdBy: originalCard)
]
