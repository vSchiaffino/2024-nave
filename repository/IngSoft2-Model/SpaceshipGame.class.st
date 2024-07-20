Class {
	#name : #SpaceshipGame,
	#superclass : #Object,
	#instVars : [
		'board',
		'dice',
		'ships',
		'cardManager'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
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

{ #category : #accessing }
SpaceshipGame >> cardsOf: aShipName [

	| aShip |
	aShip := self shipNamed: aShipName.
	^ aShip cards copy
]

{ #category : #'turn logic' }
SpaceshipGame >> handleBattleBetween: actualShip and: collidingShip [

	| actualShipDiceResult collidingShipDiceResult loserShip loserShipAllies allLosers |
	actualShipDiceResult := cardManager
		                        applyBattleModifierTo: actualShip
		                        using: dice.
	collidingShipDiceResult := cardManager
		                           applyBattleModifierTo: collidingShip
		                           using: dice.

	loserShip := actualShipDiceResult >= collidingShipDiceResult
		             ifTrue: [ collidingShip ]
		             ifFalse: [ actualShip ].

	loserShipAllies := cardManager mercenariesOf: loserShip.
	allLosers := loserShipAllies copyWith: loserShip.
	allLosers do: [ :eachLoser |
		eachLoser removeShield.
		board moveToTheStart: eachLoser ]
]

{ #category : #'turn logic' }
SpaceshipGame >> handleCollisionBetween: actualShip and: collidingShip [

	cardManager
		checkIf: actualShip
		shouldBattleWith: collidingShip
		in: self
]

{ #category : #'turn logic' }
SpaceshipGame >> handleMovementOf: aShip [

	| diceResult diceModifier |
	diceResult := dice throw.
	diceModifier := cardManager diceModifierTo: aShip.
	board move: aShip by: diceResult + diceModifier.
	board applyEffectTo: aShip.
	board checkIf: aShip IsCollidingIn: self
]

{ #category : #accessing }
SpaceshipGame >> indexOfCellWith: aShipName [

	^ board indexOfCellWith: (self shipNamed: aShipName)
]

{ #category : #initialization }
SpaceshipGame >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: anAmountOfCells wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation lengthInParsecs: aLengthInParsecs cellGenerator: aCellGenerator deck: aDeck [

	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship
			         named: eachShipName
			         cards:
			         (OrderedCollection
				          with: aDeck drawCard
				          with: aDeck drawCard) ].
	board := Board
		         withShips: ships
		         lengthInParsecs: aLengthInParsecs
		         lapsToWin: aNumberOfLapsToWin
		         wormholeStart: aWormholeStartLocation
		         wormholeEnd: aWormholeEndLocation
		         cellGenerator: aCellGenerator.
	cardManager := CardManager
		               withShips: ships
		               withBoard: board
		               withDeck: aDeck.
	^ self
]

{ #category : #accessing }
SpaceshipGame >> isOver [

	^ board anyShipCompletedAllLaps
]

{ #category : #accessing }
SpaceshipGame >> lapsOf: aShipName [

	^ board lapsOf: (self shipNamed: aShipName)
]

{ #category : #'game controls' }
SpaceshipGame >> playCard: aCard by: aShipName [

	self playCard: aCard by: aShipName target: nil
]

{ #category : #'game controls' }
SpaceshipGame >> playCard: aCard by: aShipName target: aTarget [

	| aShip |
	self verifyIsNotOver.
	aShip := self shipNamed: aShipName.
	cardManager playCard: aCard by: aShip target: aTarget
]

{ #category : #accessing }
SpaceshipGame >> ranking [

	^ board orderedShips collect: [ :ship | ship name ]
]

{ #category : #'helper methods' }
SpaceshipGame >> shipNamed: aShipName [

	| aShip |
	aShip := ships detect: [ :eachShip | eachShip name = aShipName ].
	^ aShip
]

{ #category : #'game controls' }
SpaceshipGame >> skipsNextTurn [

	| shipToPlay |
	shipToPlay := ships first.
	shipToPlay restoreShields.
	ships removeFirst.
	ships addLast: shipToPlay
]

{ #category : #'game controls' }
SpaceshipGame >> throwDice [

	| shipToPlay  |
	self verifyIsNotOver.
	shipToPlay := ships first.
	shipToPlay playIn: self.
	ships removeFirst.
	ships addLast: shipToPlay
]

{ #category : #'helper methods' }
SpaceshipGame >> verifyIsNotOver [

	self isOver ifTrue: [ Error signal: 'game is over!' ]
]

{ #category : #'helper methods' }
SpaceshipGame >> verifyIsOver [

	self isOver ifFalse: [ Error signal: 'game is not over yet' ]
]

{ #category : #accessing }
SpaceshipGame >> winner [

	self verifyIsOver.
	^ board shipWithCompletedLaps name
]
