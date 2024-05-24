Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'cells'
	],
	#classInstVars : [
		'cells'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }

Board class >> length: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation [
	^(self new) initializeWithLength: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation
]

{ #category : #accessing }
Board >> at: index place: someShips [

	| theCell |
	theCell := cells at: index.
	theCell entersAll: someShips
]

{ #category : #testing }
Board >> indexOfCellWith: aShip [

	| cellWithAShip |
	cellWithAShip := self whereIs: aShip.
	^ (1 to: cells size) detect: [ :index |
		  (cells at: index) = cellWithAShip ]
]

{ #category : #initialization }
Board >> initializeWithLength: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation [

	| wormholePair |
	cells := OrderedCollection new.
	wormholePair := WormholeCell newPair.
	1 to: anAmountOfCells do: [ :index | cells add: NormalCell new ].
	WormholeCell
		newPairIn: cells
		start: aWormholeStartLocation
		end: aWormholeEndLocation.
	^ self
]

{ #category : #testing }
Board >> isLastCellOccupied [

	^ cells last isOccupied
]

{ #category : #'as yet unclassified' }
Board >> move: aShip by: anAmountOfTimes [

	| actualCell nextCell theCellIndex |
	actualCell := self whereIs: aShip.
	theCellIndex := (cells indexOf: actualCell) + anAmountOfTimes min:
		                cells size.
	nextCell := cells at: theCellIndex.
	actualCell leaves: aShip.
	nextCell enters: aShip
]

{ #category : #'as yet unclassified' }
Board >> whereIs: aShip [

	^ cells detect: [ :eachCell | eachCell includes: aShip ]
]

{ #category : #'as yet unclassified' }
Board >> winner [

	^ cells last firstShip
]
