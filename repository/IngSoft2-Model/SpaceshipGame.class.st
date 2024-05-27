Class {
	#name : #SpaceshipGame,
	#superclass : #Object,
	#instVars : [
		'board',
		'dice',
		'ships',
		'lapsToWin'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation [

	^ self new
		  initializeWith: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
]

{ #category : #accessing }
SpaceshipGame >> indexOfCellWith: aShipName [

	| aShip |
	aShip := ships detect: [ :eachShip | eachShip name = aShipName ].
	^ board indexOfCellWith: aShip
]

{ #category : #initialization }
SpaceshipGame >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation [

	lapsToWin := aNumberOfLapsToWin.
	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship named: eachShipName ].
	board := Board
		         length: anAmountOfCells
		         wormholeStart: aWormholeStartLocation
		         wormholeEnd: aWormholeEndLocation.
	board at: 1 place: ships.
	^ self
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> isOver [

	^ ships anySatisfy: [ :eachShip | eachShip lapsCompleted >= lapsToWin ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> playsNextTurn [

	| shipToPlay diceResult actualShipDiceResult collidingShipDiceResult loserShip |
	self verifyIsNotOver.
	diceResult := dice throw.
	shipToPlay := ships first.
	board
		move: shipToPlay
		by: diceResult
		ifCollision: [ :actualShip :collidingShip |
			actualShipDiceResult := dice throw.
			collidingShipDiceResult := dice throw.
			loserShip := actualShipDiceResult >= collidingShipDiceResult
				             ifTrue: [ collidingShip ]
				             ifFalse: [ actualShip ].
			loserShip removeShield.
			board moveToTheStart: loserShip ].

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

	^ (ships detect: [ :eachShip | eachShip lapsCompleted >= lapsToWin ]) name.
]
