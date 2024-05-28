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

	^ self new
		  initializeWithLength: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
]

{ #category : #accessing }
Board >> at: index place: someShips [

	| theCell |
	theCell := cells at: index.
	theCell entersAll: someShips
]

{ #category : #accessing }
Board >> indexOfCellWith: aShip [

	^ cells detectIndex: [ :eachCell | eachCell includes: aShip ]
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

{ #category : #'as yet unclassified' }
Board >> move: aShip by: times ifCollision: aBlockIfCollision [

	| actualCell nextCell actualCellIndex nextCellIndex lapsDone |
	actualCell := self whereIs: aShip.
	actualCellIndex := cells indexOf: actualCell.
	nextCellIndex := actualCellIndex - 1 + times % cells size + 1.
	lapsDone := actualCellIndex - 1 + times // cells size.
	aShip addLaps: lapsDone.
	nextCell := cells at: nextCellIndex.
	actualCell leaves: aShip.
	nextCell enters: aShip.
	nextCell ifHasTwoShips: aBlockIfCollision
]

{ #category : #'as yet unclassified' }
Board >> moveToTheStart: aShip [
	| actualCell |
	actualCell := self whereIs: aShip.
	actualCell leaves: aShip.
	cells first enters: aShip
]

{ #category : #'as yet unclassified' }
Board >> whereIs: aShip [

	^ cells detect: [ :eachCell | eachCell includes: aShip ]
]
