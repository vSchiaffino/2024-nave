Class {
	#name : #RedoCard,
	#superclass : #Card,
	#instVars : [
		'lastUsedCard'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
RedoCard >> ifWasUsed: aBlockIfWasUsed [
]

{ #category : #accessing }
RedoCard >> lastCardWas: aCard [

	lastUsedCard := aCard
]

{ #category : #'as yet unclassified' }
RedoCard >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	| cardToUse |
	cardToUse := lastUsedCard class new.
	cardToUse targetShip: targetShipName.
	cardToUse targetCard: targetCard.
	cardToUse
		useIn: aBoard
		withActiveCards: someActiveCards
		withShips: someShips
]

{ #category : #'as yet unclassified' }
RedoCard >> verifyCanBeUsed: isMyTurn [

	lastUsedCard verifyCanBeUsed: isMyTurn
]
