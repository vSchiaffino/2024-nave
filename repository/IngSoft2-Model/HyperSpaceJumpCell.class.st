Class {
	#name : #HyperSpaceJumpCell,
	#superclass : #Cell,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperSpaceJumpCell >> applyEffectTo: aShip in: aBoard [

	aShip removeShield.
	aBoard move: aShip by: 4
]
