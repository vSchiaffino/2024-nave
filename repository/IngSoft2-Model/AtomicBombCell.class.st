Class {
	#name : #AtomicBombCell,
	#superclass : #Cell,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
AtomicBombCell >> applyEffectTo: aShip in: aBoard [
	aBoard removeShieldFromAllShips.
	aBoard moveAllShipsToTheStart.
]
