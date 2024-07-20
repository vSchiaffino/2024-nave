Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'discardedCards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Deck class >> cards: someCards [

	^ self new initializeWithCards: someCards
]

{ #category : #accessing }
Deck class >> length: aNumberOfCards [

	^ self new initializeWith: aNumberOfCards
]

{ #category : #drawing }
Deck >> dealTo: aShip [

	cards isEmpty ifTrue: [ self shuffleDiscarded ].
	cards isEmpty ifFalse: [ aShip receive: cards removeFirst ]
]

{ #category : #'deck control' }
Deck >> discard: aCard [

	discardedCards add: aCard
]

{ #category : #drawing }
Deck >> initializeWith: aNumberOfCards [

	| cardCreators cardCreatorBlock createdCard initialCards |
	initialCards := OrderedCollection new.
	cardCreators := {
		                [ AccelerationCard new ].
		                [ CancellationCard new ].
		                [ RedoCard new ].
		                [ RepeatCard new ].
		                [ SpeedCard new ].
		                [ MercenaryCard new ] }.
	1 to: aNumberOfCards do: [ :index |
		cardCreatorBlock := cardCreators atRandom.
		createdCard := cardCreatorBlock value.
		initialCards add: createdCard ].
	self initializeWithCards: initialCards
]

{ #category : #drawing }
Deck >> initializeWithCards: someCards [

	discardedCards := OrderedCollection new.
	cards := someCards
]

{ #category : #drawing }
Deck >> shuffleDiscarded [

	| shuffledDiscardedCards aRandomDiscardedCard |
	shuffledDiscardedCards := OrderedCollection new.
	discardedCards size timesRepeat: [
		aRandomDiscardedCard := discardedCards atRandom.
		discardedCards remove: aRandomDiscardedCard.
		shuffledDiscardedCards add: aRandomDiscardedCard ].
	cards addAll: shuffledDiscardedCards
]
