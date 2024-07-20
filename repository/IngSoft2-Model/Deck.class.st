Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Deck class >> length: aNumberOfCards [

	^ self new initializeWith: aNumberOfCards
]

{ #category : #drawing }
Deck >> dealTo: aShip [

	cards isEmpty ifFalse: [ aShip receive: cards removeFirst ]
]

{ #category : #drawing }
Deck >> drawCard [

	^ cards removeFirst
]

{ #category : #drawing }
Deck >> initializeWith: aNumberOfCards [

	| cardCreators cardCreatorBlock createdCard |
	cards := OrderedCollection new.
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
		cards add: createdCard ]
]
