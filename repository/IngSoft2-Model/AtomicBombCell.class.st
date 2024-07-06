Class {
	#name : #AtomicBombCell,
	#superclass : #Cell,
	#category : #'IngSoft2-Model'
}

{ #category : #'cell effect' }
AtomicBombCell >> applyEffectTo: aShip in: aBoard [

	aBoard removeShieldFromAllShips.
	aBoard moveAllShipsToTheStart
]
