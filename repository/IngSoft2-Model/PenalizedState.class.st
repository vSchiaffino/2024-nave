Class {
	#name : #PenalizedState,
	#superclass : #Object,
	#instVars : [
		'remainingTurns'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
PenalizedState >> initialize [

	remainingTurns := 2
]

{ #category : #'play logic' }
PenalizedState >> playAs: aShip in: aSpaceshipGame [

	remainingTurns := remainingTurns - 1.
	remainingTurns = 0 ifTrue: [ aShip endPenalty ]
	
]
