Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'cells',
		'lengthInParsecs'
	],
	#classInstVars : [
		'cells'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Board class >> length: anAmountOfCells lengthInParsecs: anAmountOfLengthInParsecs wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation [

	^ self new
		  initializeWithLength: anAmountOfCells
		  lengthInParsecs: anAmountOfLengthInParsecs
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
]

{ #category : #'as yet unclassified' }
Board >> allShips [

	^ (cells collect: [ :cell | cell ships ]) flattened
		  asOrderedCollection
]

{ #category : #'as yet unclassified' }
Board >> applyEffectTo: aShip [

	| aCell |
	aCell := self whereIs: aShip.
	aCell applyEffectTo: aShip in: self
]

{ #category : #accessing }
Board >> at: index place: someShips [

	| theCell |
	theCell := cells at: index.
	theCell entersAll: someShips
]

{ #category : #'as yet unclassified' }
Board >> if: aShip isCollidding: aBlockIfColliding [

	| aCell |
	aCell := self whereIs: aShip.
	aCell ifHasTwoShips: aBlockIfColliding
]

{ #category : #accessing }
Board >> indexOfCellWith: aShip [

	^ cells detectIndex: [ :eachCell | eachCell includes: aShip ]
]

{ #category : #initialization }
Board >> initializeWithLength: anAmountOfCells lengthInParsecs: aLengthInParsecs wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation [

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
Board >> move: aShip by: times [

	| actualCell nextCell actualCellIndex nextCellIndex lapsDone |
	actualCell := self whereIs: aShip.
	actualCellIndex := cells indexOf: actualCell.
	nextCellIndex := actualCellIndex - 1 + times % cells size + 1.
	lapsDone := actualCellIndex - 1 + times // cells size.
	aShip addLaps: lapsDone.
	nextCell := cells at: nextCellIndex.
	actualCell leaves: aShip.
	nextCell enters: aShip
]

{ #category : #'as yet unclassified' }
Board >> move: aShip byParsecs: parsecsToMove [ 
	| cellsToMove parsecsPerCell|
	parsecsPerCell := lengthInParsecs // cells size.
	cellsToMove := parsecsToMove // parsecsPerCell.
	self move: aShip by: cellsToMove
]

{ #category : #'as yet unclassified' }
Board >> moveAllShips: times except: aShip [

	| allShips |
	allShips := self allShips.
	allShips remove: aShip.
	allShips do: [ :eachShip | self move: eachShip by: times ]
]

{ #category : #'as yet unclassified' }
Board >> moveAllShipsToTheStart [

	self allShips do: [ :eachShip | self moveToTheStart: eachShip ]
]

{ #category : #'as yet unclassified' }
Board >> moveToTheStart: aShip [

	| actualCell |
	actualCell := self whereIs: aShip.
	actualCell leaves: aShip.
	cells first enters: aShip
]

{ #category : #removing }
Board >> removeShieldFromAllShips [

	self allShips do: [ :eachShip | eachShip removeShield ]
]

{ #category : #'as yet unclassified' }
Board >> whereIs: aShip [

	^ cells detect: [ :eachCell | eachCell includes: aShip ]
]
