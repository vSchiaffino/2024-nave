Class {
	#name : #WormholeCell,
	#superclass : #Cell,
	#instVars : [
		'wormholeEnd'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
WormholeCell class >> new [
	^ self error: 'Use WormholeCell newPairIn: start: end: instead.'
]

{ #category : #'instance creation' }
WormholeCell class >> newPairIn: someCells start: wormholeStartLocation end: wormholeEndLocation [

	| firstWormhole secondWormhole |
	firstWormhole := super new.
	secondWormhole := super new.
	firstWormhole initializeWith: secondWormhole.
	secondWormhole initializeWith: firstWormhole.

	someCells at: wormholeStartLocation put: (firstWormhole).
	someCells at: wormholeEndLocation put: (secondWormhole)
]

{ #category : #'cell effect' }
WormholeCell >> applyEffectTo: aShip in: aBoard [

	| aCell |
	aCell := aBoard whereIs: aShip.
	aCell leaves: aShip.
	wormholeEnd enters: aShip
]

{ #category : #initialization }
WormholeCell >> initializeWith: aWormholeCell [

	wormholeEnd := aWormholeCell
]
