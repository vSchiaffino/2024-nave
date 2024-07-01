Class {
	#name : #CancellationCard,
	#superclass : #InstantCard,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
CancellationCard >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	someActiveCards remove: targetCard.
	targetCard beRemovedWithShips: someShips
]

{ #category : #'as yet unclassified' }
CancellationCard >> verifyCanBeUsed: isMyTurn withActiveCards: someActiveCards [

	(someActiveCards anySatisfy: [ :eachCard | eachCard = targetCard ])
		ifFalse: [ Error signal: 'no such card in active cards!' ]
]
