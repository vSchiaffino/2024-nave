Class {
	#name : #MercenaryCard,
	#superclass : #PermanentCard,
	#instVars : [
		'myMercenaryShip'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
MercenaryCard >> beRemovedWith: someShips [

	myMercenaryShip beRemoved.
	someShips remove: myMercenaryShip
]

{ #category : #'as yet unclassified' }
MercenaryCard >> diceModifierTo: aShip [

	^ 0
]

{ #category : #'as yet unclassified' }
MercenaryCard >> useIn: aBoard withActiveCards: someActiveCards withShips: someShips [

	| aMercenaryName aMercenaryShip cardUser |
	cardUser := someShips first.
	someActiveCards add: self.
	aMercenaryName := 'mercenary-of-' , cardUser name , '-'
	                  , 10000 atRandom printString.
	aMercenaryShip := MercenaryShip named: aMercenaryName.
	aMercenaryShip addAlly: cardUser.
	cardUser addAlly: aMercenaryShip.

	myMercenaryShip := aMercenaryShip.
	someShips add: aMercenaryShip.
	aBoard placeAtTheStart: aMercenaryShip
]
