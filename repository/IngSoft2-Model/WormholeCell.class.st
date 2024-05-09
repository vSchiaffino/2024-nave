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
	
	aWormholePair := OrderedCollection with: firstWormhole with: secondWormhole.
	^ aWormholePair.
]

{ #category : #testing }
WormholeCell >> enters: aShip [
	wormholeEnd entersFromStart: aShip.
]

{ #category : #'as yet unclassified' }
WormholeCell >> entersFromStart: aShip [ 
	super enters: aShip.
]

{ #category : #initialization }
WormholeCell >> initializeWith: aWormholeCell [ 
	wormholeEnd := aWormholeCell
]
