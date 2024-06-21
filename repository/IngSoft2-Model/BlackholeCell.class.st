Class {
	#name : #BlackholeCell,
	#superclass : #Cell,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
BlackholeCell >> applyEffectTo: aShip in: aBoard [

	aBoard move: aShip by: -4
]
