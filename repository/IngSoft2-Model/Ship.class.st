Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'name',
		'cards',
		'battleModifier',
		'penaltyState',
		'shieldManager'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Ship class >> named: aShipName using: aDeck [

	^ self new initializeWith: aShipName using: aDeck
]

{ #category : #'battle modifier' }
Ship >> activateDoubleBattleModifier [

	battleModifier := DoubleBattleModifier new
]

{ #category : #'battle modifier' }
Ship >> activateNormalBattleModifier [

	battleModifier := NormalBattleModifier new
]

{ #category : #'shields logic' }
Ship >> addShield [

	shieldManager addShield
]

{ #category : #accessing }
Ship >> cards [

	^ cards
]

{ #category : #'penalty logic' }
Ship >> endPenalty [

	self restoreShields.
	penaltyState := NotPenalizedState new
]

{ #category : #initialization }
Ship >> initializeWith: aName using: aDeck [

	cards := OrderedCollection new.
	aDeck dealTo: self.
	aDeck dealTo: self.
	penaltyState := NotPenalizedState new.
	shieldManager := ShieldManager new.
	battleModifier := NormalBattleModifier new.
	name := aName.
	^ self
]

{ #category : #'shields logic' }
Ship >> loseShield [

	shieldManager loseShieldAs: self
]

{ #category : #accessing }
Ship >> name [

	^ name
]

{ #category : #playing }
Ship >> playIn: aGame [

	penaltyState playAs: self in: aGame.
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
Ship >> restoreShields [

	shieldManager restoreShields
]

{ #category : #'penalty logic' }
Ship >> startPenalty [

	penaltyState := PenalizedState new
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
