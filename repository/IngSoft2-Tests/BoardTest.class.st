Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BoardTest >> testWhenTryToMovesMoreThanTheLastCellItShouldMoveToTheFirstCell [

	| aBoard aShip someShips |
	aBoard := Board length: 10 wormholeStart: 3 wormholeEnd: 4.
	aShip := Ship named: 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	aBoard at: 1 place: someShips.
	aBoard move: aShip by: 10 ifCollision: [].
	self assert: (aBoard indexOfCellWith: aShip) equals: 1
]
