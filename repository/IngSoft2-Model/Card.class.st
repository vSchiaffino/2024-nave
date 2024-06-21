Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'targetCard',
		'targetShipName'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Card >> beRemovedWith: someShips [
]

{ #category : #'as yet unclassified' }
Card >> ifWasUsed: aBlockIfWasUsed [

	aBlockIfWasUsed value
]

{ #category : #accessing }
Card >> lastCardWas: aCard [

	
]

{ #category : #accessing }
Card >> targetCard: aCard [

	targetCard := aCard
]

{ #category : #accessing }
Card >> targetShip: aShipName [

	targetShipName := aShipName
]

{ #category : #'as yet unclassified' }
Card >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Card >> verifyCanBeUsed: isMyTurn [

	self subclassResponsibility
]
