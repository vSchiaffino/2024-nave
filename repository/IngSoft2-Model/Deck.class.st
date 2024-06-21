Class {
	#name : #Deck,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #drawing }
Deck >> drawCard [

	| cardCreators cardCreatorBlock |
	cardCreators := {
		                [ AccelerationCard new ].
		                [ CancellationCard new ].
		                [ RedoCard new ].
		                [ RepeatCard new ].
		                [ SpeedCard new ].
		                [ MercenaryCard new ] }.
	cardCreatorBlock := cardCreators atRandom.
	^ cardCreatorBlock value
]
