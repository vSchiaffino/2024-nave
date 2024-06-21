Class {
	#name : #SpaceshipGame,
	#superclass : #Object,
	#instVars : [
		'board',
		'dice',
		'ships',
		'activeCards',
		'deck',
		'lastUsedCard'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs [

	| defaultCellGenerator defaultDeck defaultProbabilities |
	defaultProbabilities := OrderedCollection new.
	defaultProbabilities
		add: {
				(3 / 10).
				[ NormalCell new ] };
		add: {
				(2 / 10).
				[ BlackholeCell new ] };
		add: {
				(2 / 10).
				[ HyperSpaceJumpCell new ] };
		add: {
				(1 / 10).
				[ MoonwalkCell times: 5 atRandom ] };
		add: {
				(8 / 100).
				[
				HyperJumpCell withLengths: {
							50 parsecs.
							10 parsecs.
							5 parsecs } asOrderedCollection ] };
		add: {
				(2 / 100).
				[ AtomicBombCell new ] };
		add: {
				(1 / 10).
				[ CardGivingCell new ] }.
	defaultCellGenerator := CellGenerator
		                        length: anAmountOfCells
		                        probabilites: defaultProbabilities.
	defaultDeck := Deck new.
	^ self
		  with: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  lengthInParsecs: aLengthInParsecs
		  cellGenerator: defaultCellGenerator
		  deck: defaultDeck
]

{ #category : #'as yet unclassified' }
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs cellGenerator: aCellGenerator [
	| defaultDeck |
	defaultDeck := Deck new.
	^ self new
		  initializeWith: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  lengthInParsecs: aLengthInParsecs
		  cellGenerator: aCellGenerator
		  deck: defaultDeck 
]

{ #category : #'as yet unclassified' }
SpaceshipGame class >> with: someShips lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs cellGenerator: aCellGenerator deck: aDeck [

	^ self new
		  initializeWith: someShips
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: anAmountOfCells
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  lengthInParsecs: aLengthInParsecs
		  cellGenerator: aCellGenerator
		  deck: aDeck
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> cardsOf: aShipName [

	| aShip |
	aShip := self shipNamed: aShipName.
	^ aShip cards copy
]

{ #category : #accessing }
SpaceshipGame >> indexOfCellWith: aShipName [

	^ board indexOfCellWith: (self shipNamed: aShipName)
]

{ #category : #initialization }
SpaceshipGame >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs cellGenerator: aCellGenerator deck: aDeck [

	deck := aDeck.
	activeCards := OrderedCollection new.
	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         PlayerShip
			         named: eachShipName
			         deck:
			         (OrderedCollection with: deck drawCard with: deck drawCard) ].
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

	^ board anyShipCompletedAllLaps
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> lapsOf: aShipName [

	^ board lapsOf: (self shipNamed: aShipName)
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> mercenariesOf: aShipName [

	| aShip |
	aShip := self shipNamed: aShipName.
	^ aShip allies collect: [ :eachAlly | eachAlly name ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> playCard: aCard by: aShipName [

	| aShip isShipTurn shipToPlay |
	self verifyIsNotOver.
	aShip := self shipNamed: aShipName.
	shipToPlay := ships first.
	isShipTurn := aShip = shipToPlay.
	aCard lastCardWas: lastUsedCard.
	aCard verifyCanBeUsed: isShipTurn.
	aShip
		useCard: aCard
		in: board
		withActiveCards: activeCards
		withShips: ships.
	aCard ifWasUsed: [ lastUsedCard := aCard ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> ranking [

	^ board orderedShips collect: [ :ship | ship name ]
]

{ #category : #'as yet unclassified' }
SpaceshipGame >> shipNamed: aShipName [

	| aShip |
	aShip := ships detect: [ :eachShip | eachShip name = aShipName ].
	^ aShip
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
SpaceshipGame >> throwDice [

	| shipToPlay diceResult actualShipDiceResult collidingShipDiceResult loserShip diceModifier |
	self verifyIsNotOver.
	shipToPlay := ships first.
	shipToPlay applyTurnPenaltyElse: [
		diceResult := dice throw.
		diceModifier := (activeCards collect: [ :card |
			                 card diceModifierTo: shipToPlay name ]) sumNumbers.
		board move: shipToPlay by: diceResult + diceModifier.
		board applyEffectTo: shipToPlay.
		board if: shipToPlay isCollidding: [ :actualShip :collidingShip |
			actualShip ifIsNotAlly: collidingShip do: [
				actualShipDiceResult := actualShip throw: dice.
				collidingShipDiceResult := collidingShip throw: dice.

				loserShip := actualShipDiceResult >= collidingShipDiceResult
					             ifTrue: [ collidingShip ]
					             ifFalse: [ actualShip ].
				loserShip removeShield.
				board moveToTheStart: loserShip ] ] ].

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
