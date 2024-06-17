Class {
	#name : #SpaceshipGame,
	#superclass : #Object,
	#instVars : [
		'board',
		'dice',
		'ships'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs [

	| defaultCellGenerator defaultProbabilities |
	defaultProbabilities := OrderedCollection
		                        with: {
				                        0.4.
				                        [ NormalCell new ] }
		                        with: {
				                        0.2.
				                        [ BlackholeCell new ] }
		                        with: {
				                        0.2.
				                        [ HyperSpaceJumpCell new ] }
		                        with: {
				                        0.1.
				                        [ MoonwalkCell times: 5 atRandom ] }
		                        with: {
				                        0.08.
				                        [
				                        HyperJumpCell withParsecs:
					                        #( 50 10 5 ) asOrderedCollection ] }
		                        with: {
				                        0.02.
				                        [ AtomicBombCell new ] }.
	defaultCellGenerator := CellGenerator
		                        length: anAmountOfCells
		                        probabilites: defaultProbabilities.
	^ self
		  with: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  lengthInParsecs: aLengthInParsecs
		  cellGenerator: defaultCellGenerator
]

{ #category : #'as yet unclassified' }
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs cellGenerator: aCellGenerator [

	^ self new
		  initializeWith: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  lengthInParsecs: aLengthInParsecs
		  cellGenerator: aCellGenerator
]

{ #category : #accessing }
SpaceshipGame >> indexOfCellWith: aShipName [

	| aShip |
	aShip := ships detect: [ :eachShip | eachShip name = aShipName ].
	^ board indexOfCellWith: aShip
]

{ #category : #initialization }
SpaceshipGame >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs cellGenerator: aCellGenerator [

	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship named: eachShipName ].
	board := Board
		         withShips: ships
		         lengthInParsecs: aLengthInParsecs
		         lapsToWin: aNumberOfLapsToWin
		         wormholeStart: aWormholeStartLocation
		         wormholeEnd: aWormholeEndLocation
		         cellGenerator: aCellGenerator.
	^ self
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> isOver [

	^ board anyShipCompletedAllLaps.
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> lapsOf: aShipName [

	| aShip |
	aShip := ships detect: [ :eachShip | eachShip name = aShipName ].
	^ board lapsOf: aShip.
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> playsNextTurn [

	| shipToPlay diceResult actualShipDiceResult collidingShipDiceResult loserShip |
	self verifyIsNotOver.
	shipToPlay := ships first.
	shipToPlay applyTurnPenaltyElse: [
		diceResult := dice throw.
		board move: shipToPlay by: diceResult.
		board applyEffectTo: shipToPlay.
		board if: shipToPlay isCollidding: [ :actualShip :collidingShip |
			actualShipDiceResult := dice throw.
			collidingShipDiceResult := dice throw.
			loserShip := actualShipDiceResult >= collidingShipDiceResult
				             ifTrue: [ collidingShip ]
				             ifFalse: [ actualShip ].
			loserShip removeShield.
			board moveToTheStart: loserShip ] ].

	ships removeFirst.
	ships addLast: shipToPlay
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> ranking [

	^board orderedShips collect: [ :ship | ship name ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> skipsNextTurn [
	| shipToPlay |
	shipToPlay := ships first.
	shipToPlay restoreShields.
	ships removeFirst.
	ships addLast: shipToPlay
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> verifyIsNotOver [

	self isOver ifTrue: [ Error signal: 'game is over!' ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> verifyIsOver [

	self isOver ifFalse: [ Error signal: 'game is not over yet' ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> winner [

	self verifyIsOver.
	^ board shipWithCompletedLaps name
]
