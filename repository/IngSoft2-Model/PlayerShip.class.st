Class {
	#name : #PlayerShip,
	#superclass : #Ship,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
PlayerShip class >> named: aName deck: aDeck [

	^ self new initializeWith: aName cards: aDeck
]

{ #category : #accessing }
PlayerShip >> cards [

	^ cards
]

{ #category : #initialization }
PlayerShip >> initializeWith: aName cards: someCards [

	self initializeWith: aName.
	cards := someCards.
	^ self
]

{ #category : #'as yet unclassified' }
PlayerShip >> receive: aCard [

	cards add: aCard
]

{ #category : #removing }
PlayerShip >> removeShield [

	allies do: [ :eachAlly | eachAlly removeShield ].
	shields := shields - 1.
	shields = 0 ifTrue: [ penalty := 2 ]
]

{ #category : #'as yet unclassified' }
PlayerShip >> throw: aDice [

	| myResult myAlliesResult |
	myResult := aDice throw.
	myAlliesResult := (allies collect: [ :eachAlly | aDice throw ]) sumNumbers.
	^ myResult + myAlliesResult
]

{ #category : #'as yet unclassified' }
PlayerShip >> updateLapsIfRequired: aBlockToUpdateLaps [

	aBlockToUpdateLaps value
]

{ #category : #'as yet unclassified' }
PlayerShip >> useCard: aCard in: aBoard withActiveCards: someActiveCards withShips: someShips [

	self verifyHas: aCard.
	aCard useIn: aBoard withActiveCards: someActiveCards withShips: someShips.
	cards remove: aCard
]

{ #category : #'as yet unclassified' }
PlayerShip >> verifyHas: aCard [

	(cards includes: aCard) ifFalse: [
		Error signal: 'that card is not in deck' ]
]
