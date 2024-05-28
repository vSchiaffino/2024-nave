Class {
	#name : #HyperSpaceJump,
	#superclass : #Cell,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperSpaceJump >> applyEffectTo: aShip in: aBoard [

	aShip removeShield.
	aBoard move: aShip by: 4
	
]
