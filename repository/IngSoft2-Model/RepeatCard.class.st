Class {
	#name : #RepeatCard,
	#superclass : #InstantCard,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
RepeatCard >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	aBoard applyLastEffectTo: targetShipName
]
