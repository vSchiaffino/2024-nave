Class {
	#name : #PermanentCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
PermanentCard >> verifyCanBeUsed: isMyTurn withActiveCards: someActiveCards [

	isMyTurn ifFalse: [ Error signal: 'it is not your turn!' ].
]
