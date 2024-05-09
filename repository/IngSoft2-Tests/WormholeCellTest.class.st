Class {
	#name : #WormholeCellTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
WormholeCellTest >> testWhenEntersFromFirstWormHoleThenSecondWormholeShouldIncludeTheShipAndFirstWormholeShouldNot [
	| aShip aWormholePair firstWormhole secondWormhole |
	aShip := Ship withName: 'test-ship-1'.
	aWormholePair := WormholeCell newPair.
	firstWormhole := aWormholePair at: 1.
	secondWormhole := aWormholePair at: 2.
	
	firstWormhole enters: aShip.
	
	self assert: (secondWormhole includes: aShip).
	self deny: (firstWormhole includes: aShip).
]

{ #category : #tests }
WormholeCellTest >> testWhenEntersFromSecondWormHoleThenFirstWormholeShouldIncludeTheShipAndSecondWormholeShouldNot [
	| aShip aWormholePair firstWormhole secondWormhole |
	aShip := Ship withName: 'test-ship-1'.
	aWormholePair := WormholeCell newPair.
	firstWormhole := aWormholePair at: 1.
	secondWormhole := aWormholePair at: 2.
	
	secondWormhole enters: aShip.
	
	self assert: (firstWormhole includes: aShip).
	self deny: (secondWormhole includes: aShip).
]
