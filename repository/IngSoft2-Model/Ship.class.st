Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'shields',
		'penalty',
		'name',
		'allies',
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Ship class >> named: aShipName cards: someCards [

	^ self new initializeWith: aShipName cards: someCards
]

{ #category : #'as yet unclassified' }
Ship >> addAlly: anAlly [

	allies add: anAlly
]

{ #category : #accessing }
Ship >> allies [

	^ allies
]

{ #category : #'as yet unclassified' }
Ship >> applyTurnPenaltyElse: aBlockIfNotPenalized [

	penalty > 0
		ifTrue: [
			penalty = 2 ifTrue: [ shields := 3 ].
			penalty := penalty - 1 ]
		ifFalse: [ aBlockIfNotPenalized value ]
]

{ #category : #accessing }
Ship >> cards [

	^ cards
]

{ #category : #'as yet unclassified' }
Ship >> ifIsNotAlly: aShip do: aBlockIfNotAlly [

	((allies includes: aShip) or: (aShip allies includes: self)) ifFalse: [ aBlockIfNotAlly value ]
]

{ #category : #initialization }
Ship >> initializeWith: aName cards: someCards [

	allies := OrderedCollection new.
	name := aName.
	shields := 3.
	penalty := 0.
	cards := someCards.
	^ self
]

{ #category : #accessing }
Ship >> name [

	^ name
]

{ #category : #'as yet unclassified' }
Ship >> receive: aCard [

	cards add: aCard
]

{ #category : #removing }
Ship >> removeAlly: aMercenaryShip [

	allies remove: aMercenaryShip ifAbsent: [  ]
]

{ #category : #removing }
Ship >> removeShield [

	allies do: [ :eachAlly | eachAlly removeShield ].
	shields := shields - 1.
	shields = 0 ifTrue: [ penalty := 2 ]
]

{ #category : #'as yet unclassified' }
Ship >> restoreShields [

	shields := 3
]

{ #category : #'as yet unclassified' }
Ship >> throw: aDice [

	| myResult myAlliesResult |
	myResult := aDice throw.
	myAlliesResult := (allies collect: [ :eachAlly | aDice throw ]) sumNumbers.
	^ myResult + myAlliesResult
]

{ #category : #'as yet unclassified' }
Ship >> updateLapsIfRequired: aBlockToUpdateLaps [

	aBlockToUpdateLaps value
]

{ #category : #'as yet unclassified' }
Ship >> useCard: aCard in: aBoard withActiveCards: someActiveCards withShips: someShips [

	self verifyHas: aCard.
	aCard useIn: aBoard withActiveCards: someActiveCards withShips: someShips.
	cards remove: aCard
]

{ #category : #'as yet unclassified' }
Ship >> verifyHas: aCard [

	(cards includes: aCard) ifFalse: [
		Error signal: 'that card is not in deck' ]
]
