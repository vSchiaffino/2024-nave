Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'shields',
		'penalty',
		'name',
		'cards',
		'battleModifier'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Ship class >> named: aShipName cards: someCards [

	^ self new initializeWith: aShipName cards: someCards
]

{ #category : #adding }
Ship >> activateDoubleBattleModifier [

	battleModifier := DoubleBattleModifier new
]

{ #category : #adding }
Ship >> activateNormalBattleModifier [

	battleModifier := NormalBattleModifier new
]

{ #category : #accessing }
Ship >> cards [

	^ cards
]

{ #category : #initialization }
Ship >> initializeWith: aName cards: someCards [

	battleModifier := NormalBattleModifier new.
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

{ #category : #playing }
Ship >> playIn: aGame [

	penalty > 0
		ifTrue: [
			penalty = 2 ifTrue: [ shields := 3 ].
			penalty := penalty - 1 ]
		ifFalse: [ aGame handleMovementOf: self ]
]

{ #category : #'deck logic' }
Ship >> receive: aCard [

	cards add: aCard
]

{ #category : #'deck logic' }
Ship >> removeFromDeck: aCard [

	cards remove: aCard
]

{ #category : #'shields logic' }
Ship >> removeShield [

	shields := shields - 1.
	shields = 0 ifTrue: [ penalty := 2 ]
]

{ #category : #'shields logic' }
Ship >> restoreShields [

	shields := 3
]

{ #category : #'dice throw' }
Ship >> throw: aDice [

	| normalDiceResult modifiedDiceResult |
	normalDiceResult := aDice throw.
	modifiedDiceResult := battleModifier
		                      modify: normalDiceResult
		                      to: self.
	^ modifiedDiceResult
]

{ #category : #'deck logic' }
Ship >> verifyHas: aCard [

	(cards includes: aCard) ifFalse: [
		Error signal: 'that card is not in deck' ]
]
