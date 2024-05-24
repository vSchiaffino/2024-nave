Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BoardTest >> testWhenShipIsMovedToTheLastCellThenLastCellShouldBeOccupied [

	| aBoard aShip someShips |
	aBoard := Board length: 10 wormholeStart: 4 wormholeEnd: 5.
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	aBoard at: 1 place: someShips.
	aBoard move: aShip by: 9.
	self assert: aBoard isLastCellOccupied
]

{ #category : #tests }
BoardTest >> testWhenTryToMovesOutsideBoardThenGivesTheLastCell [

	| aBoard aShip someShips |
	aBoard := Board length: 10 wormholeStart: 3 wormholeEnd: 4.
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	aBoard at: 1 place: someShips.
	aBoard move: aShip by: 12.
	self assert: (aBoard indexOfCellWith: aShip) equals: 10
]
