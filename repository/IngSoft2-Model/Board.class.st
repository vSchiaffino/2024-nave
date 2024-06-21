Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'cells',
		'lengthInParsecs',
		'lapsPerShip',
		'lapsToWin',
		'lastCellEffectUsed'
	],
	#classInstVars : [
		'cells'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Board class >> withShips: someShips lengthInParsecs: anAmountOfLengthInParsecs lapsToWin: aNumberOfLapsToWin wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation cellGenerator: aCellGenerator [

	^ self new
		  initializeWith: someShips
		  lengthInParsecs: anAmountOfLengthInParsecs
		  lapsToWin: aNumberOfLapsToWin
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  cellGenerator: aCellGenerator
]

{ #category : #'as yet unclassified' }
Board >> allShips [

	^ lapsPerShip keys asSet
]

{ #category : #'as yet unclassified' }
Board >> anyShipCompletedAllLaps [

	^ lapsPerShip anySatisfy: [ :lapsByEachShip |
		  lapsByEachShip >= lapsToWin ]
]

{ #category : #'as yet unclassified' }
Board >> applyEffectTo: aShip [

	| aCell |
	aCell := self whereIs: aShip.
	lastCellEffectUsed := aCell.
	aCell applyEffectTo: aShip in: self
]

{ #category : #'as yet unclassified' }
Board >> applyLastEffectTo: aShipName [

	| aShip |
	aShip := self allShips detect: [ :ship | ship name = aShipName ].
	lastCellEffectUsed applyEffectTo: aShip in: self
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
Board >> initializeWith: someShips lengthInParsecs: aLengthInParsecs lapsToWin: aNumberOfLapsToWin wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation cellGenerator: aCellGenerator [

	lastCellEffectUsed := NormalCell new.
	lengthInParsecs := aLengthInParsecs.
	lapsToWin := aNumberOfLapsToWin.
	lapsPerShip := Dictionary new.
	someShips do: [ :eachShip | lapsPerShip at: eachShip put: 0 ].

	cells := aCellGenerator generate.
	WormholeCell
		newPairIn: cells
		start: aWormholeStartLocation
		end: aWormholeEndLocation.

	(cells at: 1) entersAll: someShips.
	^ self
]

{ #category : #'as yet unclassified' }
Board >> lapsOf: aShip [ 
	^ lapsPerShip at: aShip.
]

{ #category : #'as yet unclassified' }
Board >> move: aShip by: anAmount [

	| actualCell nextCell actualCellIndex nextCellIndex actualShipLaps lapsChangeAmount cellsToMove |
	cellsToMove := anAmount toCellsOf: self.

	actualCell := self whereIs: aShip.
	actualCellIndex := cells indexOf: actualCell.
	nextCellIndex := actualCellIndex - 1 + cellsToMove % cells size + 1.

	aShip updateLapsIfRequired: [
		actualShipLaps := lapsPerShip at: aShip.
		lapsChangeAmount := actualCellIndex - 1 + cellsToMove // cells size.
		lapsPerShip at: aShip put: actualShipLaps + lapsChangeAmount ].

	nextCell := cells at: nextCellIndex.
	actualCell leaves: aShip.
	nextCell enters: aShip
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

{ #category : #'ship order' }
Board >> orderedShips [

	| sortByRankBlock |
	sortByRankBlock := [ :aShip :anotherShip |
	                   (self rank: aShip) >= (self rank: anotherShip) ].
	^ (self allShips sorted: sortByRankBlock) asOrderedCollection
]

{ #category : #'as yet unclassified' }
Board >> parsecsPerCell [

	^ lengthInParsecs // cells size
]

{ #category : #'as yet unclassified' }
Board >> placeAtTheStart: aShip [

	cells first enters: aShip
]

{ #category : #accessing }
Board >> rank: aShip [

	| cellIndex lapsDone |
	cellIndex := cells indexOf: (self whereIs: aShip).
	lapsDone := lapsPerShip at: aShip.
	^ cellIndex + (lapsDone * cells size)
]

{ #category : #removing }
Board >> removeShieldFromAllShips [

	self allShips do: [ :eachShip | eachShip removeShield ]
]

{ #category : #'as yet unclassified' }
Board >> shipWithCompletedLaps [

	^ lapsPerShip keys detect: [ :eachShip |
		  (lapsPerShip at: eachShip) >= lapsToWin ]
]

{ #category : #'as yet unclassified' }
Board >> whereIs: aShip [

	^ cells detect: [ :eachCell | eachCell includes: aShip ]
]
