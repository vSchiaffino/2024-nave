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

	| wormholePair notRandomCellsCount randomCellsCount normalCellsCount blackholeCellsCount hyperspacejumpCount moonwalkCount hyperjumpCount atomicbombCount cellsDistribution normalsCells blackholeCells hyperspacejumpCells moonwalkCells hyperjumpCells atomicbombCells roundDifference |
	notRandomCellsCount := 2. "The wormhole cells are not random, and they are 2"
	randomCellsCount := anAmountOfCells - 2.

	normalCellsCount := (0.4 * randomCellsCount) floor.
	blackholeCellsCount := (0.2 * randomCellsCount) floor.
	hyperspacejumpCount := (0.2 * randomCellsCount) floor.
	moonwalkCount := (0.1 * randomCellsCount) floor.
	hyperjumpCount := (0.08 * randomCellsCount) floor.
	atomicbombCount := (0.02 * randomCellsCount) floor.

	roundDifference := randomCellsCount - normalCellsCount
	                   - blackholeCellsCount - hyperspacejumpCount
	                   - moonwalkCount - hyperjumpCount - atomicbombCount.
	normalCellsCount := normalCellsCount + roundDifference.

	normalsCells := OrderedCollection new.
	normalCellsCount timesRepeat: [ normalsCells add: NormalCell new ].

	blackholeCells := OrderedCollection new.
	blackholeCellsCount timesRepeat: [ blackholeCells add: BlackholeCell new ].

	hyperspacejumpCells := OrderedCollection new.
	hyperspacejumpCount timesRepeat:  [
		hyperspacejumpCells add: HyperSpaceJump new ].

	moonwalkCells := OrderedCollection new.
	moonwalkCount timesRepeat: [ moonwalkCells  add: (MoonwalkCell times: (5 atRandom)) ]. "Pongo N como un random entre 1 y 5"

	hyperjumpCells := OrderedCollection new.
	hyperjumpCount timesRepeat: [
		hyperjumpCells add:
			(HyperJumpCell withParsecs: #( 50 10 5 ) asOrderedCollection) ]. "Valor fijo de parsecs, despues se puede cambiar"

	atomicbombCells := OrderedCollection new.
	atomicbombCount timesRepeat: [ atomicbombCells add: AtomicBombCell new ].

	cellsDistribution := OrderedCollection new.
	cellsDistribution addAll: normalsCells.
	cellsDistribution addAll: blackholeCells.
	cellsDistribution addAll: hyperspacejumpCells.
	cellsDistribution addAll: moonwalkCells.
	cellsDistribution addAll: hyperjumpCells.
	cellsDistribution addAll: atomicbombCells.

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
