Class {
	#name : #DoubleBattleModifier,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'battle modifier' }
DoubleBattleModifier >> modify: aDiceResult to: aShip [

	aShip activateNormalBattleModifier.
	^ aDiceResult * 2
]
