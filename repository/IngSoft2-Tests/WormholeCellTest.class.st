Class {
	#name : #WormholeCellTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
WormholeCellTest >> testWhenCreateAWormholePairInCellsAndAShipEntersToTheWormholeThenTheShipIsInTheOtherWormhole [

	| cells aWormholeStartLocation aWormholeEndLocation aShip |
	aShip := 'test-name-1'.
	cells := OrderedCollection new.
	aWormholeStartLocation := 3.
	aWormholeEndLocation := 7.
	1 to: 10 do: [ :index | cells add: Cell new ].
	WormholeCell
		newPairIn: cells
		start: aWormholeStartLocation
		end: aWormholeEndLocation.

	(cells at: 3) enters: aShip.
	self assert: ((cells at: 7) includes: aShip)
]

{ #category : #tests }
WormholeCellTest >> testWhenEntersFromFirstWormHoleThenSecondWormholeShouldIncludeTheShipAndFirstWormholeShouldNot [

	| aShip aWormholePair firstWormhole secondWormhole |
	aShip := 'test-ship-1'.
	aWormholePair := WormholeCell newPair.
	firstWormhole := aWormholePair at: 1.
	secondWormhole := aWormholePair at: 2.

	firstWormhole enters: aShip.

	self assert: (secondWormhole includes: aShip).
	self deny: (firstWormhole includes: aShip)
]

{ #category : #tests }
WormholeCellTest >> testWhenEntersFromSecondWormHoleThenFirstWormholeShouldIncludeTheShipAndSecondWormholeShouldNot [

	| aShip aWormholePair firstWormhole secondWormhole |
	aShip := 'test-ship-1'.
	aWormholePair := WormholeCell newPair.
	firstWormhole := aWormholePair at: 1.
	secondWormhole := aWormholePair at: 2.

	secondWormhole enters: aShip.

	self assert: (firstWormhole includes: aShip).
	self deny: (secondWormhole includes: aShip)
]
