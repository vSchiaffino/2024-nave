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
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs [

	^ self new
		  initializeWith: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  lengthInParsecs: aLengthInParsecs
]

{ #category : #accessing }
SpaceshipGame >> indexOfCellWith: aShipName [

	| aShip |
	aShip := ships detect: [ :eachShip | eachShip name = aShipName ].
	^ board indexOfCellWith: aShip
]

{ #category : #initialization }
SpaceshipGame >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs [

	lapsToWin := aNumberOfLapsToWin.
	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship named: eachShipName ].
	board := Board
		         length: anAmountOfCells
		         lengthInParsecs: aLengthInParsecs
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

	| sortedCollection shipPosition shipLaps shipPositionArray rankingBlock |
	self verifyIsOver.
	rankingBlock := [ :firstShip :secondShip |
	                firstShip second = secondShip second
		                ifTrue: [ firstShip third >= secondShip third ]
		                ifFalse: [ firstShip second > secondShip second ] ].

	sortedCollection := SortedCollection sortBlock: rankingBlock.

	ships do: [ :eachShip |
		shipPosition := board indexOfCellWith: eachShip.
		shipLaps := eachShip lapsCompleted.
		shipPositionArray := OrderedCollection
			                     with: eachShip
			                     with: shipLaps
			                     with: shipPosition.
		sortedCollection add: shipPositionArray ].


	^ sortedCollection collect: [ :position | position first name ]
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

	^ (ships detect: [ :eachShip | eachShip lapsCompleted >= lapsToWin ]) name.
]
