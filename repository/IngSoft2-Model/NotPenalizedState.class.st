Class {
	#name : #NotPenalizedState,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'play logic' }
NotPenalizedState >> playAs: aShip in: aSpaceshipGame [

	aSpaceshipGame handleMovementOf: aShip
]
