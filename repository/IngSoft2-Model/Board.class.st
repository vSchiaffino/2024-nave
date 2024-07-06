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

{ #category : #'instance creation' }
Board class >> withShips: someShips lengthInParsecs: anAmountOfLengthInParsecs lapsToWin: aNumberOfLapsToWin wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation cellGenerator: aCellGenerator [

	^ self new
		  initializeWith: someShips
		  lengthInParsecs: anAmountOfLengthInParsecs
		  lapsToWin: aNumberOfLapsToWin
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  cellGenerator: aCellGenerator
]

{ #category : #accessing }
Board >> allShips [

	^ lapsPerShip keys asSet
]

{ #category : #'helper methods' }
Board >> anyShipCompletedAllLaps [

	^ lapsPerShip anySatisfy: [ :lapsByEachShip |
		  lapsByEachShip >= lapsToWin ]
]

{ #category : #'cell effect' }
Board >> applyEffectTo: aShip [

	| aCell |
	aCell := self whereIs: aShip.
	lastCellEffectUsed := aCell.
	aCell applyEffectTo: aShip in: self
]

{ #category : #'cell effect' }
Board >> applyLastEffectTo: aShipName [

	| aShip |
	aShip := self allShips detect: [ :ship | ship name = aShipName ].
	lastCellEffectUsed applyEffectTo: aShip in: self
]

{ #category : #'helper methods' }
Board >> checkIf: shipToPlay IsCollidingIn: aGame [

	| aCell |
	aCell := self whereIs: shipToPlay.
	aCell checkCollisionIn: aGame
]

{ #category : #accessing }
Board >> indexOfCellWith: aShip [

	^ cells detectIndex: [ :eachCell | eachCell includes: aShip ]
]

{ #category : #initialization }
Board >> initializeWith: someShips lengthInParsecs: aLengthInParsecs lapsToWin: aNumberOfLapsToWin wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation cellGenerator: aCellGenerator [

	aWormholeStartLocation = aWormholeEndLocation ifTrue: [
		Error signal: 'wormhole cannot start and end in the same cell!' ].
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

{ #category : #accessing }
Board >> lapsOf: aShip [ 
	^ lapsPerShip at: aShip.
]

{ #category : #movement }
Board >> move: aShip by: anAmount [

	| actualCell nextCell actualCellIndex nextCellIndex actualShipLaps lapsChangeAmount cellsToMove |
	cellsToMove := anAmount toCellsOf: self.

	actualCell := self whereIs: aShip.
	actualCellIndex := cells indexOf: actualCell.
	nextCellIndex := actualCellIndex - 1 + cellsToMove % cells size + 1.
	actualShipLaps := lapsPerShip at: aShip.
	lapsChangeAmount := actualCellIndex - 1 + cellsToMove // cells size.
	lapsPerShip at: aShip put: actualShipLaps + lapsChangeAmount.

	nextCell := cells at: nextCellIndex.
	actualCell leaves: aShip.
	nextCell enters: aShip
]

{ #category : #movement }
Board >> moveAllShips: times except: aShip [

	| allShips |
	allShips := self allShips.
	allShips remove: aShip.
	allShips do: [ :eachShip | self move: eachShip by: times ]
]

{ #category : #movement }
Board >> moveAllShipsToTheStart [

	self allShips do: [ :eachShip | self moveToTheStart: eachShip ]
]

{ #category : #movement }
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

{ #category : #accessing }
Board >> parsecsPerCell [

	^ lengthInParsecs // cells size
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

{ #category : #accessing }
Board >> shipWithCompletedLaps [

	^ lapsPerShip keys detect: [ :eachShip |
		  (lapsPerShip at: eachShip) >= lapsToWin ]
]

{ #category : #accessing }
Board >> whereIs: aShip [

	^ cells detect: [ :eachCell | eachCell includes: aShip ]
]
