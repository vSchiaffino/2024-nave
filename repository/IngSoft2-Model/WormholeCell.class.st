Class {
	#name : #WormholeCell,
	#superclass : #Cell,
	#instVars : [
		'wormholeEnd'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
WormholeCell class >> newPair [

	| firstWormhole secondWormhole aWormholePair |
	firstWormhole := self new.
	secondWormhole := self new.
	firstWormhole initializeWith: secondWormhole.
	secondWormhole initializeWith: firstWormhole.

	aWormholePair := OrderedCollection
		                 with: firstWormhole
		                 with: secondWormhole.
	^ aWormholePair
]

{ #category : #'instance creation' }
WormholeCell class >> newPairIn: someCells start: wormholeStartLocation end: wormholeEndLocation [

	| wormholePair |
	wormholePair := self newPair.
	someCells at: wormholeStartLocation put: (wormholePair at: 1).
	someCells at: wormholeEndLocation put: (wormholePair at: 2)
]

{ #category : #'as yet unclassified' }
WormholeCell >> applyEffectTo: aShip in: aBoard [
	wormholeEnd teleport: aShip.
]

{ #category : #testing }
WormholeCell >> enters: aShip [
	wormholeEnd teleport: aShip
]

{ #category : #initialization }
WormholeCell >> initializeWith: aWormholeCell [

	wormholeEnd := aWormholeCell
]

{ #category : #'as yet unclassified' }
WormholeCell >> teleport: aShip [

	ships add: aShip
]
