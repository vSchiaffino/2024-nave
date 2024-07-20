Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
GameTest >> testARandomMatchEnds [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (Die of: 30)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 15
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 200
					withNumberOfCards: 20.
		
	[aGame isOver] whileFalse: [ 
		aGame throwDice.
	]
]

{ #category : #tests }
GameTest >> testIfAShipCrossesTheLineToWinTheGameBecauseOfARepeatCardItShouldWin [
	| aShip aGame someShips someDice anotherShip deck cardsToDraw aRepeatCard someCells |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: AccelerationCard new.

	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 1
		         wormholeEnd: 4
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aRepeatCard := deck first.
	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: aShip.
	self assert: (aGame winner) equals: aShip
]

{ #category : #tests }
GameTest >> testIfAShipPlaysAInstantCardAndItsNotItsTurnShouldApplyEffect [

	| aShip aGame someShips someDice cardsToDraw anotherShip anAccelerationCard aCancellationCard shipCards anotherShipCards |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: CancellationCard new
		               with: AccelerationCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	shipCards := aGame cardsOf: aShip.
	anotherShipCards := aGame cardsOf: anotherShip.
	anAccelerationCard := shipCards first.
	aCancellationCard := anotherShipCards second.

	aGame playCard: anAccelerationCard by: aShip.
	aGame throwDice. "turno test-ship-1"
	aGame
		playCard: aCancellationCard
		by: anotherShip
		target: anAccelerationCard.
	aGame throwDice. "turno test-ship-2"

	self assert: (aGame indexOfCellWith: anotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testIfAShipPlaysAPermanentCardAndItsNotItsTurnShouldThrowAnError [

	| aShip aGame someShips someDice cards cardsToDraw anotherShip anAccelerationCard anotherAccelerationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: AccelerationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	anAccelerationCard := cards first.
	anotherAccelerationCard := cards second.
	aGame playCard: anAccelerationCard by: aShip.
	aGame throwDice. "turno test-ship-1"

	self
		should: [aGame playCard: anotherAccelerationCard by: aShip]
		raise: Error
		withMessage: 'it is not your turn!'
]

{ #category : #tests }
GameTest >> testIfAWormholeStartsAndEndsInTheSameCellItShouldThrowAnError [

	| aShip aGame someShips someDice cardsToDraw |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: AccelerationCard new.
	self
		should: [
			aGame := SpaceshipGame
				         with: someShips
				         lapsToWin: 1
				         using: someDice
				         withCells: 10
				         wormholeStart: 1
				         wormholeEnd: 1
				         lengthInParsecs: 100
				         cellGenerator:
				         (FixedCellGenerator allNormalCellsWith: 10)
				         deck: (Deck cards: cardsToDraw) ]
		raise: Error
		withMessage: 'wormhole cannot start and end in the same cell!'
]

{ #category : #tests }
GameTest >> testIfGameIsNotOverThenWinnerShouldThrowError [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-2'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 6 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
					withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	self
		should: [ aGame winner ]
		raise: Error
		withMessage: 'game is not over yet'
]

{ #category : #tests }
GameTest >> testIfNoTurnWasPlayedThenRepeatCardShouldNotHaveEffect [

	| aShip aGame someShips someDice anotherShip deck cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aRepeatCard := deck first.
	aGame playCard: aRepeatCard by: aShip target: aShip.
	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testIfStackTwoSpeedCardsThenShouldMoveTwoCellsMore [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck anotherSpeedCard cardsToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: SpeedCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aSpeedCard := deck first.
	anotherSpeedCard := deck second.

	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame playCard: anotherSpeedCard by: aShip target: aShip.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 7
]

{ #category : #tests }
GameTest >> testIfTryToUseTheSameCardAgainShouldRaiseError [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck someCardToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 4 ) asOrderedCollection)).
	someCardToDraw := OrderedCollection
		                  with: SpeedCard new
		                  with: SpeedCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: someCardToDraw).
	deck := aGame cardsOf: aShip.
	aSpeedCard := deck first.
	aGame playCard: aSpeedCard by: aShip target: aShip.
	self
		should: [ aGame playCard: aSpeedCard by: aShip target: aShip ]
		raise: Error
		withMessage: 'that card is not in deck'
]

{ #category : #tests }
GameTest >> testWhenAMercenaryBattlesThenTheMercenaryCardUserShouldNotHelp [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 4 1 1 10 6 5 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno test-ship-3"

	self assert: (aGame indexOfCellWith: aShip) equals: 5.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenAShipAndItsMercenaryLosesABattleThenTheyShouldMoveToTheStart [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll: (Set with:
			             (LoadedDie sequence:
				              #( 1 2 3 1 5 1 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno test-ship-3"
	aGame throwDice. "turno test-ship-1"

	self assert: (aGame indexOfCellWith: aShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 3.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenAShipCompletedTheRequiredLapsThenShouldBeOver [

	| aShip aGame someDice someShips |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 5 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 5
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
							withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 5).
	aGame throwDice.
	self assert: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenAShipCompletedThreeLapsNumberOfLapsShouldBeThree [

	| aShip aGame someDice someShips |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 10 10 11 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 4
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	self assert: (aGame lapsOf: aShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenAShipEntersIntoAMoonwalkCellAndOneShipGoesBackMoreThanTheFirstCellThenItShouldNotCountThePreviousLap [

	| aShip someShips aGame someDice someCells anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 12 6 7 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: (MoonwalkCell times: 3).
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).

	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self deny: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenAShipEntersIntoAMoonwalkCellThenItShouldStayInThatCell [

	| aShip someShips aGame someDice someCells anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 3 4 6 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: (MoonwalkCell times: 3).
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 7
]

{ #category : #tests }
GameTest >> testWhenAShipEntersIntoAMoonwalkCellWithThreeStepsThenAllTheOtherShipsShouldGoBackThreeSteps [

	| aShip someShips aGame someDice someCells anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 3 4 6 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: (MoonwalkCell times: 3).
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenAShipEntersToABlackholeCellThenLandsInAnotherBlackholeCellThenSecondEffectShouldNotBeApplied [

	| aShip someShips aGame someDice someCells anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 6 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: BlackholeCell new.
	someCells add: NormalCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 8
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenAShipEntersToAWormholeThenItShouldBeOnTheOtherWormhole [

	| aShip someShips aGame someDice |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 3 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 15
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 200
					withNumberOfCards: 20.
	aGame throwDice.
	
	self assert: (aGame indexOfCellWith: aShip) equals: 5.
]

{ #category : #tests }
GameTest >> testWhenAShipHasTwoMercenariesThenTheyShouldHelpInABattle [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip yetAnotherAnotherShip anotherMercenaryCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	yetAnotherAnotherShip := 'test-ship-4'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip
		             with: yetAnotherAnotherShip.
	someDice := Dice withAll: (Set with:
			             (LoadedDie sequence:
				              #( 1 2 3 1 1 1 1 2 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	anotherMercenaryCard := cards second.
	aGame playCard: aMercenaryCard by: aShip target: anotherShip.
	aGame playCard: anotherMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno test-ship-3"
	aGame throwDice. "turno test-ship-4"

	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 3.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 4.
	self assert: (aGame indexOfCellWith: yetAnotherAnotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenAShipLandsInACardGivingCellTheShipShouldHaveOneMoreCard [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: (CardGivingCell deck: (Deck length: 1)).
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 3
		         wormholeEnd: 4
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.

	self assert: (aGame cardsOf: aShip) size equals: 3
]

{ #category : #tests }
GameTest >> testWhenAShipPlaysASpeedCardThenTheOtherShipShouldntMoveOneMoreCell [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck cardsToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: SpeedCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aSpeedCard := deck first.
	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame throwDice.

	aGame throwDice.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 5
]

{ #category : #tests }
GameTest >> testWhenAShipPlaysAnAccelerationCardThenAllShipsShouldMoveOneMoreCell [

	| aShip aGame someShips someDice anotherShip deck cardsToDraw yetAnotherShip anAccelerationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 10 20 30 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: AccelerationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	anAccelerationCard := deck first.
	aGame playCard: anAccelerationCard by: aShip.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 12.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 22.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 32
]

{ #category : #tests }
GameTest >> testWhenAShipPlaysCancellationCardAndCardToRemoveIsSpeedCardAndThereIsNoSpeedCardActiveShouldThrowAnError [

	| aShip aGame someShips someDice anotherShip cardsToDraw aCancellationCard anAccelerationCard aSpeedCard aDeck anotherDeck |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 7 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: AccelerationCard new
		               with: CancellationCard new
		               with: CancellationCard new
		               with: SpeedCard new
		               with: SpeedCard new.
	aSpeedCard := cardsToDraw third.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).

	aDeck := aGame cardsOf: aShip.
	anotherDeck := aGame cardsOf: anotherShip.
	anAccelerationCard := aDeck first.
	aCancellationCard := anotherDeck first.


	aGame playCard: anAccelerationCard by: aShip.
	aGame throwDice.
	self
		should: [
			aGame
				playCard: aCancellationCard
				by: anotherShip
				target: aSpeedCard ]
		raise: Error
		withMessage: 'no such card in active cards!'
]

{ #category : #tests }
GameTest >> testWhenAShipPlaysCancellationCardAndThereAreZeroActiveCardsShouldThrowAnError [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck cardsToDraw aCancellationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 7 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (LoadedDeck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aSpeedCard := deck first.
	aCancellationCard := deck second.
	aGame throwDice.
	self
		should: [ aGame playCard: aCancellationCard by: anotherShip target: aSpeedCard ]
		raise: Error
		withMessage: 'no such card in active cards!'
]

{ #category : #tests }
GameTest >> testWhenAShipPlaysMercenaryCardAndBattlesAnotherShipShouldAddItsDiceThrowResultToTheBattle [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection with: aShip with: anotherShip with: yetAnotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 10 19 )
					              asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2"

	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1.
]

{ #category : #tests }
GameTest >> testWhenAShipPlaysMercenaryCardAndBattlesWithItsMercenaryThenTheyShouldNotBattle [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection with: aShip with: anotherShip with: yetAnotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 2 1 )
					              asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip .
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno test-ship-3"

	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 2.
]

{ #category : #tests }
GameTest >> testWhenAShipTargetsItselfWithAMercenaryCardShouldThrowAnError [

	| aShip aGame someShips someDice cardsToDraw aMercenaryCard aShipCards |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll: (Set with:
			             (LoadedDie sequence:
				              #( 10 1 1 10 20 20 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aShipCards := aGame cardsOf: aShip.
	aMercenaryCard := aShipCards first.

	self
		should: [ aGame playCard: aMercenaryCard by: aShip target: aShip ]
		raise: Error
		withMessage: 'you cannot target yourself as a Mercenary!'
]

{ #category : #tests }
GameTest >> testWhenAShipWasDoubledAndAnotherShipBattlesWithItThenShouldDoubleItDiceResult [

	| aShip someShips aGame someDice anotherShip someCards aDoubleCard cardsToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 2 3 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: DoubleCard new
		               with: DoubleCard new
		               with: DoubleCard new
		               with: DoubleCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 4
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: aShip.
	aDoubleCard := someCards first.

	aGame playCard: aDoubleCard by: aShip target: aShip.

	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenAShipWasDoubledAndBattlesThenShouldDoubleItDiceResult [

	| aShip someShips aGame someDice anotherShip someCards aDoubleCard cardsToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 2 3 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: DoubleCard new
		               with: DoubleCard new
		               with: DoubleCard new
		               with: DoubleCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 4
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: anotherShip.
	aDoubleCard := someCards first.

	aGame playCard: aDoubleCard by: anotherShip  target: anotherShip.

	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenAShipWasDoubledAndIsAMercenaryThenIfHelpsItsDiceShouldBeDoubled [

	| aShip someShips aGame someDice anotherShip someCards aDoubleCard cardsToDraw aMercenaryCard yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 10 5 3 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: DoubleCard new
		               with: MercenaryCard new
		               with: DoubleCard new
		               with: DoubleCard new
		               with: DoubleCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 4
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: anotherShip.
	aMercenaryCard := someCards first.
	aDoubleCard := someCards second.

	aGame throwDice.
	aGame playCard: aMercenaryCard by: anotherShip target: yetAnotherShip.
	aGame playCard: aDoubleCard by: anotherShip target: yetAnotherShip.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenASpeedEffectAndMercenaryEffectAreActiveThenMercenaryShouldHelp [

	| aShip aGame someShips someDice anotherShip aSpeedCard cardsToDraw aMercenaryCard aDeck yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 1 10 2 5 5 6 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: MercenaryCard new
		               with: CancellationCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aDeck := aGame cardsOf: aShip.
	aSpeedCard := aDeck first.
	aMercenaryCard := aDeck second.

	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame playCard: aMercenaryCard by: aShip target: anotherShip.
	aGame throwDice.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 3.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenASpeedEffectAndMercenaryEffectAreActiveThenMercenaryShouldNotBattleWithCardUser [

	| aShip aGame someShips someDice anotherShip aSpeedCard cardsToDraw aMercenaryCard aDeck |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 2 10 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: MercenaryCard new
		               with: CancellationCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aDeck := aGame cardsOf: aShip.
	aSpeedCard := aDeck first.
	aMercenaryCard := aDeck second.

	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame playCard: aMercenaryCard by: aShip target: anotherShip.
	aGame throwDice.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 3.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenBothShipsHaveMercenariesThenBothShouldHelp [

	| aShip aGame someShips someDice cardsToDraw aMercenaryCard anotherShip yetAnotherShip yetAnotherAnotherShip someCards someOtherCards anotherMercenaryCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	yetAnotherAnotherShip := 'test-ship-4'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip
		             with: yetAnotherAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 1 1 5 5 6 3 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: aShip.
	someOtherCards := aGame cardsOf: anotherShip.

	aMercenaryCard := someCards first.
	anotherMercenaryCard := someOtherCards first.

	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"

	aGame playCard: anotherMercenaryCard by: anotherShip target: yetAnotherAnotherShip.
	aGame throwDice. "turno test-ship-2"


	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenCancelAMercenaryCardThenShouldNotApplyTheCardEffect [

	| aShip aGame someShips someDice cardsToDraw aMercenaryCard anotherShip aShipCards anotherShipCards aCancellationCard yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 1 1 10 20 20 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: CancellationCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aShipCards := aGame cardsOf: aShip.
	anotherShipCards := aGame cardsOf: anotherShip.

	aMercenaryCard := aShipCards first.
	aCancellationCard := anotherShipCards first.

	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame playCard: aCancellationCard by: anotherShip target: aMercenaryCard.

	aGame throwDice.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenCancelAMercenaryShipWhenThereIsAnotherPermanentCardItShouldNotApplyMercenaryEffect [

	| aShip aGame someShips someDice anotherShip aSpeedCard cardsToDraw aMercenaryCard aDeck otherDeck aCancellationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 10 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: MercenaryCard new
		               with: CancellationCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aDeck := aGame cardsOf: aShip.
	otherDeck := aGame cardsOf: anotherShip.
	aSpeedCard := aDeck first.
	aMercenaryCard := aDeck second.
	aCancellationCard := otherDeck first.

	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame playCard: aMercenaryCard by: aShip target: anotherShip.
	aGame playCard: aCancellationCard by: anotherShip target: aMercenaryCard.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 3.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenCancelASpeedCardThenShouldNotApplyTheCardEffect [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck cardsToDraw aCancellationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 7 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (LoadedDeck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aSpeedCard := deck first.
	aCancellationCard := deck second.
	aGame playCard: aSpeedCard by: aShip target: anotherShip.
	aGame throwDice.
	aGame playCard: aCancellationCard by: anotherShip target: aSpeedCard.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 5
]

{ #category : #tests }
GameTest >> testWhenCancelAnAccelerationCardThenShouldNotApplyTheCardEffect [

	| aShip aGame someShips someDice cardsToDraw anotherShip aShipCards anotherShipCards aCancellationCard yetAnotherShip anAccelerationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 2 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: AccelerationCard new
		               with: CancellationCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aShipCards := aGame cardsOf: aShip.
	anotherShipCards := aGame cardsOf: anotherShip.

	anAccelerationCard := aShipCards first.
	aCancellationCard := anotherShipCards first.

	aGame playCard: anAccelerationCard by: aShip.
	aGame playCard: aCancellationCard by: anotherShip target: anAccelerationCard.

	aGame throwDice.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenGameIsOverAndTryToUseAPermanentCardThenShouldThrowError [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck cardsToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 20 ) asOrderedCollection)).

	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: SpeedCard new
		               with: SpeedCard new
		               with: SpeedCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aGame throwDice.

	deck := aGame cardsOf: anotherShip.
	aSpeedCard := deck first.
	self
		should: [
		aGame playCard: aSpeedCard by: anotherShip target: anotherShip ]
		raise: Error
		withMessage: 'game is over!'
]

{ #category : #tests }
GameTest >> testWhenGameIsOverAndTryToUseAnInstantCardThenShouldThrowError [

	| aShip aGame someShips someDice deck cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 20 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aGame throwDice.

	deck := aGame cardsOf: aShip.
	aRepeatCard := deck first.
	self
		should: [ aGame playCard: aRepeatCard by: aShip  target: aShip]
		raise: Error
		withMessage: 'game is over!'
]

{ #category : #tests }
GameTest >> testWhenGameIsOverThenTheRankingShouldShowTheCorrectOrderOfShips [

	| aShip aGame someShips someDice anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 3 2 1 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	self assert: aGame ranking equals: {
			aShip.
			anotherShip.
			yetAnotherShip } asOrderedCollection
]

{ #category : #tests }
GameTest >> testWhenHasTwoLapsAndAShipCompletedTwoLapsShouldBeOver [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 3 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 5
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 5).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	self assert: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasAtomicBombCellAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice someCells cardsToDraw aRepeatCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 4 5 8 4 5 5 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: AtomicBombCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 1
		         wormholeEnd: 4
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aRepeatCard := (aGame cardsOf: aShip) first.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: aShip.

	self assert: (aGame indexOfCellWith: aShip) equals: 1.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasBlackHoleAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice someCells cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 8 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: BlackholeCell new.
	someCells add: NormalCell new.

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aRepeatCard := (aGame cardsOf: aShip) first.
	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: aShip.

	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasCardGivingCellAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice someCells cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: (CardGivingCell deck: (Deck length: 2)).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aRepeatCard := (aGame cardsOf: aShip) first.
	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: aShip.

	self assert: (aGame cardsOf: aShip) size equals: 3
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasHyperJumpAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice someCells cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: (HyperJumpCell withLengths:
			 (OrderedCollection with: 10 parsecs with: 10 parsecs)).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aRepeatCard := (aGame cardsOf: aShip) first.
	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: aShip.

	self assert: (aGame indexOfCellWith: aShip) equals: 4
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasHyperSpaceJumpAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice someCells cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aRepeatCard := (aGame cardsOf: aShip) first.
	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: aShip.

	self assert: (aGame indexOfCellWith: aShip) equals: 10
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasMoonwalkCellAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice someCells cardsToDraw aRepeatCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 11 2 8 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: (MoonwalkCell times: 1).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 12
		         wormholeEnd: 13
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aRepeatCard := (aGame cardsOf: yetAnotherShip) first.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice. "cae en MoonWalk"
	aGame playCard: aRepeatCard by: yetAnotherShip target: aShip.

	self assert: (aGame indexOfCellWith: aShip) equals: 12.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 8
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasNormalCellThenShouldHaveNoEffect [

	| aShip aGame someShips someDice anotherShip deck cardsToDraw aRepeatCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aGame throwDice.
	deck := aGame cardsOf: aShip.
	aRepeatCard := deck first.
	aGame playCard: aRepeatCard by: aShip target: aShip.
	self assert: (aGame indexOfCellWith: aShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenLastEffectWasWormholeCellAndUseTheRepeatCardThenShouldApplyTheEffect [

	| aShip someShips aGame someDice cardsToDraw anotherShip someCards aRepeatCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).

	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new
		               with: RepeatCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: aShip.
	aRepeatCard := someCards first.

	aGame throwDice.
	aGame playCard: aRepeatCard by: aShip target: anotherShip .
	self assert: (aGame indexOfCellWith: anotherShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenMercenaryShipBattlesWithTheMercenaryCardUserTheyShouldNotBattle [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 2 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aGame playCard: aMercenaryCard by: aShip target: anotherShip.
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno test-ship-1"

	self assert: (aGame indexOfCellWith: aShip) equals: 3.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenNoCardsLeftInDeckThenCardGivingCellShouldNotGiveAnyCard [

	| aShip someShips aGame someDice someCells aDeck |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	aDeck := Deck length: 2.
	someCells := OrderedCollection new.
	someCells
		add: NormalCell new;
		add: (CardGivingCell deck: aDeck);
		add: NormalCell new;
		add: NormalCell new;
		add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: aDeck.

	aGame throwDice.
	self assert: (aGame cardsOf: aShip) size equals: 2
]

{ #category : #tests }
GameTest >> testWhenNoShipCompletedTheLapsThenGameShouldNotBeOver [

	| aShip aGame someDice someShips |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 6 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 4
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 4).
	aGame throwDice.
	self deny: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenPlayAAccelerationCardAndThenARedoCardThenShouldApplyTheAcelerationEffectTwice [

	| aShip aGame someShips someDice anotherShip deck cardsToDraw anAccelerationCard aRedoCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: RedoCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	anAccelerationCard := deck first.
	aRedoCard := deck second.
	aGame playCard: anAccelerationCard by: aShip.
	aGame playCard: aRedoCard by: aShip.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 7
]

{ #category : #tests }
GameTest >> testWhenPlayACancellationCardAndThenARedoCardThenShouldApplyTheCancellationEffectAgain [

	| aShip aGame someShips someDice anotherShip cardsToDraw anAccelerationCard aRedoCard aDeck otherDeck aCancellationCard anotherAccelerationCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: AccelerationCard new
		               with: AccelerationCard new
		               with: CancellationCard new
		               with: RedoCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aDeck := aGame cardsOf: aShip.
	otherDeck := aGame cardsOf: anotherShip.

	anAccelerationCard := aDeck first.
	anotherAccelerationCard := aDeck second.
	aCancellationCard := otherDeck first.
	aRedoCard := otherDeck second.


	aGame playCard: anAccelerationCard by: aShip.
	aGame playCard: anotherAccelerationCard by: aShip.
	aGame throwDice.

	aGame
		playCard: aCancellationCard
		by: anotherShip
		target: anAccelerationCard.


	aGame
		playCard: aRedoCard
		by: anotherShip
		target: anotherAccelerationCard.

	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 4.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenPlayAMercenaryCardAndItsNotTheShipTurnThenShouldThrow [

    | aShip aGame someShips someDice cardsToDraw aMercenaryCard anotherShip someCards |
    aShip := 'test-ship-1'.
    anotherShip := 'test-ship-2'.
    someShips := OrderedCollection with: aShip with: anotherShip.
    someDice := Dice withAll:
                    (Set with:
                         (LoadedDie sequence:
                              #( 1 1 5 5 6 3 ) asOrderedCollection)).
    cardsToDraw := OrderedCollection
                       with: MercenaryCard new
                       with: MercenaryCard new
                       with: MercenaryCard new
                       with: MercenaryCard new.
    aGame := SpaceshipGame
                 with: someShips
                 lapsToWin: 2
                 using: someDice
                 withCells: 100
                 wormholeStart: 98
                 wormholeEnd: 99
                 lengthInParsecs: 100
                 cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
                 deck: (Deck cards: cardsToDraw).
    someCards := aGame cardsOf: aShip.
    aMercenaryCard := someCards first.

    aGame throwDice. "turno test-ship-1"
    self
        should: [ aGame playCard: aMercenaryCard by: aShip target: anotherShip]
        raise: Error
        withMessage: 'it is not your turn!'
]

{ #category : #tests }
GameTest >> testWhenPlayARepeatCardAndThenARedoCardThenShouldRepeatTheEffectTwice [

	| aShip aGame someShips someDice cardsToDraw aRedoCard aDeck aRepeatCard someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: RepeatCard new
		               with: RedoCard new
		               with: CancellationCard new
		               with: RedoCard new.

	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	1 to: 100 do: [ :index | someCells add: HyperSpaceJumpCell new ].
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
		         deck: (Deck cards: cardsToDraw).
	aGame throwDice.
	aDeck := aGame cardsOf: aShip.
	aRepeatCard := aDeck first.
	aRedoCard := aDeck second.

	aGame playCard: aRepeatCard by: aShip target: aShip.
	aGame playCard: aRedoCard by: aShip target: aShip.

	self assert: (aGame indexOfCellWith: aShip) equals: 14
]

{ #category : #tests }
GameTest >> testWhenPlaysAMercenaryCardThenPlaysARedoCardThenShouldAddAMercenaryToTheUser [

	| aShip aGame someShips someDice someCardsToDraw cards aRedoCard anotherShip aMercenaryCard yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 1 ) asOrderedCollection)).
	someCardsToDraw := OrderedCollection
		                   with: MercenaryCard new
		                   with: RedoCard new
		                   with: SpeedCard new
		                   with: SpeedCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: someCardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aRedoCard := cards second.

	aGame playCard: aMercenaryCard by: aShip target: anotherShip.
	aGame playCard: aRedoCard by: aShip target: yetAnotherShip.

	aGame throwDice. "turno de test-ship-1"
	aGame throwDice. "turno de test-ship-2"
	aGame throwDice. "turno de test-ship-3"
	self assert: (aGame indexOfCellWith: aShip) equals: 2.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenPlaysASpeedCardThenPlaysARedoCardThenPlaysAnotherRedoCardShouldMoveThreeMoreCells [

    | aShip aGame someShips someDice aSpeedCard someCardsToDraw someCells anotherCardsToDraw cards aRedoCard anotherRedoCard |
    aShip := 'test-ship-1'.
    someShips := OrderedCollection with: aShip.
    someDice := Dice withAll:
                    (Set with:
                         (LoadedDie sequence: #( 1 1 ) asOrderedCollection)).
    someCardsToDraw := OrderedCollection
                           with: SpeedCard new
                           with: RedoCard new.
    anotherCardsToDraw := OrderedCollection with: RedoCard new.
    someCells := OrderedCollection new.
    someCells
        add: NormalCell new;
        add: (CardGivingCell deck: (Deck cards: anotherCardsToDraw));
        add: NormalCell new;
        add: NormalCell new;
        add: NormalCell new;
        add: NormalCell new;
        add: NormalCell new;
        add: NormalCell new;
        add: NormalCell new;
        add: NormalCell new.

    aGame := SpaceshipGame
                 with: someShips
                 lapsToWin: 2
                 using: someDice
                 withCells: someCells size
                 wormholeStart: 8
                 wormholeEnd: 9
                 lengthInParsecs: 100
                 cellGenerator: (FixedCellGenerator cells: someCells)
                 deck: (Deck cards: someCardsToDraw).

    aGame throwDice.
    cards := aGame cardsOf: aShip.
    aSpeedCard := cards first.
    aRedoCard := cards second.
    anotherRedoCard := cards third.

    aGame playCard: aSpeedCard by: aShip target: aShip.
    aGame playCard: aRedoCard by: aShip target: aShip.
    aGame playCard: anotherRedoCard by: aShip target: aShip.
    aGame throwDice.
    self assert: (aGame indexOfCellWith: aShip) equals: 6
]

{ #category : #tests }
GameTest >> testWhenPlaysASpeedCardThenPlaysARedoCardThenShouldMoveTwoMoreCells [

	| aShip aGame someShips someDice someCardsToDraw aDeck aSpeedCard aRedoCard |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	someCardsToDraw := OrderedCollection
		                   with: SpeedCard new
		                   with: RedoCard new
		                   with: SpeedCard new
		                   with: SpeedCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: someCardsToDraw).
	aDeck := aGame cardsOf: aShip.
	aSpeedCard := aDeck first.
	aRedoCard := aDeck second.
	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame playCard: aRedoCard by: aShip target: aShip.

	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 4
]

{ #category : #tests }
GameTest >> testWhenPlaysASpeedCardThenShouldMoveOneMoreCell [

	| aShip aGame someShips someDice anotherShip aSpeedCard deck cardsToDraw |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 4 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: SpeedCard new
		               with: SpeedCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	deck := aGame cardsOf: aShip.
	aSpeedCard := deck first.
	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 6
]

{ #category : #tests }
GameTest >> testWhenSecondShipsLosesTwoShieldsAndThenAnotherShieldDueToAtomicBombEffectThenItShouldLoseTwoTurns [

	| aShip someShips aGame someDice someCells anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with:
			             (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 1 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: AtomicBombCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).

	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	"Loser Turn"
	aGame throwDice.
	aGame throwDice.
	"Loser Turn"
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 3.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipAndItsMercenaryLoseThreeTimesThenTheyShouldLoseTwoTurns [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 5 5 11 20 1 11 5 5 0 20 1 11 5 5 0 0 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	aMercenaryCard := cards first.
	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"
	aGame throwDice. "turno test-ship-2 p"
	aGame throwDice. "turno de mercenaria"

	aGame throwDice. "turno test-ship-1 p"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno de mercenaria"

	aGame throwDice. "turno test-ship-1 p"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno de mercenaria penalizada"

	aGame throwDice. "turno test-ship-1 penalizada"
	aGame throwDice. "turno test-ship-2"
	aGame throwDice. "turno de mercenaria penalizada"
	aGame throwDice. "turno test-ship-1 penalizada"

	self assert: (aGame indexOfCellWith: aShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipEntersManyTimesToAHyperjumpCellThenShouldMoveAccordingToTheParsecSequence [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 10 9 8 ) asOrderedCollection)).
	someCells := OrderedCollection new.

	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: (HyperJumpCell withLengths: {
				 2 parsecs.
				 10 parsecs.
				 20 parsecs } asOrderedCollection).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells)
]

{ #category : #tests }
GameTest >> testWhenShipEntersToABlackholeCellThenShouldGoBackFourCells [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 6 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: BlackholeCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAHyperJumpCellThenShouldMoveTheDesiredAmountOfLightyears [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add:
		(HyperJumpCell withLengths: { 60 lightYears } asOrderedCollection).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).

	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 5
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAHyperJumpCellThenShouldMoveTheDesiredAmountOfParsecs [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add:
		(HyperJumpCell withLengths: { 10 parsecs } asOrderedCollection).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).

	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 4
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAHyperSpaceJumpCellAndThatShipLosesTwoTimesShouldLoseTwoTurns [

	| aShip someShips aGame someDice someCells anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with:
			             (LoadedDie sequence:
				              #( 1 5 9 10 6 1 9 10 2 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 1
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 10.
	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAHyperSpaceJumpCellThenShouldGoForwardFourCells [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 1
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 6
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAHyperSpaceJumpCellThreeTimesInARowItShouldLoseTwoTurns [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 1 1 1 10 10 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: HyperSpaceJumpCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 1
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self deny: aGame isOver.
	self assert: (aGame indexOfCellWith: aShip) equals: 16
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAHyperjumpCellAndParsecIsNotEnoughToMoveOneCellThenShouldStayInTheHyperjumpCell [

	| aShip someShips aGame someDice someCells |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add:
		(HyperJumpCell withLengths: { 5 parsecs } asOrderedCollection).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).

	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenShipEntersToAnAtomicBombCellAllShipsShouldGoBackToTheBeginning [

	| aShip someShips aGame someDice someCells anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 2 5 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: AtomicBombCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1.
	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipHasTwoShieldsThenUseADefendCardThenShouldHaveThreeShields [

	| aShip someShips aGame someDice anotherShip cardsToDraw someCards aDefendCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 1 4 10 5 1 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: anotherShip.
	aDefendCard := someCards first.

	aGame throwDice.
	aGame throwDice. " pelea"
	
	aGame playCard: aDefendCard by: anotherShip target: anotherShip.
	
	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"
	
	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pierde turno"

	aGame throwDice.
	aGame throwDice. "pierde turno"

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipHasTwoShieldsThenUseADefendCardWhenTheShieldsAreRestoredShouldRestoreOnlyThree [

	| aShip someShips aGame someDice anotherShip cardsToDraw someCards aDefendCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 1 4 10 5 1 1 1 7 10 5 1 8
				                 10 5 1 9 10 5 1 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: anotherShip.
	aDefendCard := someCards first.

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame playCard: aDefendCard by: anotherShip target: anotherShip.

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pierde turno"

	aGame throwDice.
	aGame throwDice. "pierde turno"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pierde turno"

	aGame throwDice.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipIsInFirstCellAndAskForTheIndexOfThatCellShouldBeTheFirstCell [

	| aShip aGame someShips someDice |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 3
		         wormholeEnd: 4
		         lengthInParsecs: 100
					withNumberOfCards: 20.

	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipIsInLastCellThenPlaysNextTurnShouldThrowError [

	| aShip aGame someShips someDice |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 1
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	self
		should: [ aGame throwDice ]
		raise: Error
		withMessage: 'game is over!'
]

{ #category : #tests }
GameTest >> testWhenShipIsInLastCellThenTheIndexOfThatCellShouldBeTheLastIndex [

	| aShip aGame someShips someDice |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 9 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 1
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 10
]

{ #category : #tests }
GameTest >> testWhenShipLosesTwoBattlesThenSkipsATurnThenLoseAnotherBattleThenItMovesInNextTurn [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 1 4 10 5 1 1 )
					              asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice. "+1"
	aGame throwDice. "pierde shield"

	aGame throwDice. "+1"
	aGame throwDice. "pierde shield"

	aGame throwDice. "+1"
	aGame skipsNextTurn. "recupera los shields"

	aGame throwDice. "+1"
	aGame throwDice. "1" "pierde shield"

	aGame throwDice. "+1"
	aGame throwDice. "+1"

	self assert: (aGame indexOfCellWith: anotherShip) equals: 2
]

{ #category : #tests }
GameTest >> testWhenShipRunsOutOfShieldsThenShouldLoseTwoTurns [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 4 4 )
					              asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipRunsOutOfShieldsThenTheOtherShipMoves [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 4 4 )
					              asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 20
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 20).
	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: aShip) equals: 12
]

{ #category : #tests }
GameTest >> testWhenShipRunsOutOfShieldsThenTwoTurnsLaterCanPlay [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 4 4 4 2 )
					              asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.

	aGame throwDice.
	aGame throwDice.



	self assert: (aGame indexOfCellWith: anotherShip) equals: 3
]

{ #category : #tests }
GameTest >> testWhenShipUsesDefendCardThenRunsOutOfShieldsThenShouldRunOfShieldsWithFourLoses [

	| aShip someShips aGame someDice anotherShip cardsToDraw someCards aDefendCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 1 1 1 6 10 5 1 7 10 5
				                 1 8 10 5 1 9 10 5 1 1 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: anotherShip.
	aDefendCard := someCards first.
	aGame playCard: aDefendCard by: anotherShip target: anotherShip.

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pierde turno"

	aGame throwDice.
	aGame throwDice. "pierde turno"

	aGame throwDice. " pelea"
	aGame throwDice. 

	aGame throwDice. " pelea"
	aGame throwDice. 

	aGame throwDice. " pelea"
	aGame throwDice. 

	aGame throwDice. " pelea"
	aGame throwDice. 

	aGame throwDice. "pierde turno"
	aGame throwDice.

	aGame throwDice. "pierde turno"

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipUsesTwoDefendCardInARowHavingThreeShieldsThenShouldHaveFourShields [

	| aShip someShips aGame someDice anotherShip cardsToDraw someCards aDefendCard anotherDefendCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll: (Set with: (LoadedDie sequence:
				              #( 1 1 10 5 1 2 10 5 1 3 10 5 1 4 10 5 1 1 )
					              asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new
		               with: DefendCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	someCards := aGame cardsOf: anotherShip.
	aDefendCard := someCards first.
	anotherDefendCard := someCards second.

	aGame playCard: aDefendCard by: anotherShip target: anotherShip.
	aGame playCard: anotherDefendCard by: anotherShip target: anotherShip.
	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pelea"

	aGame throwDice.
	aGame throwDice. " pierde turno"

	aGame throwDice.
	aGame throwDice. "pierde turno"

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenShipsEntersToAWormholeAndThereIsAnotherShipInTheOtherWormholeThenTheyShouldBattle [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 4 6 1 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenTheFirstShipCompletedTheRequiredLapsThenShouldBeTheWinner [

	| aShip anotherShip someShips someDice aGame |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	self assert: aGame winner equals: aShip
]

{ #category : #tests }
GameTest >> testWhenThirdShipEntersToAnAtomicBombCellAndThenFirstShipRollsNineInATenCellBoardWithOneLapItShouldWin [

	| aShip someShips aGame someDice someCells anotherShip yetAnotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 2 5 10 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: AtomicBombCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 3
		         wormholeEnd: 4
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.
	aGame throwDice.

	self assert: aGame isOver.
	self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1.
	self assert: (aGame indexOfCellWith: aShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenTwoShipsBattleAndItsADrawTheSecondShipGoesBackToFirstCell [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 1 1 10 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenTwoShipsBattleAndTheFirstShipWinsTheSecondShipGoesBackToFirstCell [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 10 5 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 20
		         using: someDice
		         withCells: 10
		         wormholeStart: 9
		         wormholeEnd: 10
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aGame throwDice.
	aGame throwDice.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenTwoShipsEnterToAHyperJumpCellThenShouldMoveTheDesiredAmountOfParsecsOrLightyears [

	| aShip someShips aGame someDice someCells anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	someCells := OrderedCollection new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: (HyperJumpCell withLengths: {
				 10 parsecs.
				 90 lightYears } asOrderedCollection).
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	someCells add: NormalCell new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: someCells size
		         wormholeStart: 5
		         wormholeEnd: 6
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).

	aGame throwDice.
	aGame throwDice.
	self assert: (aGame indexOfCellWith: aShip) equals: 4.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 6
]

{ #category : #tests }
GameTest >> testWhenTwoShipsHaveMercenariesAndCancelOneThenTheOtherShouldKeepHavingOne [

	| aShip aGame someShips someDice cardsToDraw aMercenaryCard anotherShip aShipCards anotherShipCards aCancellationCard yetAnotherShip anotherMercenaryCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 10 1 1 10 20 20 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: CancellationCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 10
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10)
		         deck: (Deck cards: cardsToDraw).
	aShipCards := aGame cardsOf: aShip.
	anotherShipCards := aGame cardsOf: anotherShip.

	aMercenaryCard := aShipCards first.
	anotherMercenaryCard := anotherShipCards first.
	aCancellationCard := anotherShipCards second.

	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice.

	aGame playCard: anotherMercenaryCard by: anotherShip target: aShip.

	aGame throwDice.
	aGame
		playCard: aCancellationCard
		by: anotherShip
		target: aMercenaryCard.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 2.
		self assert: (aGame indexOfCellWith: yetAnotherShip) equals: 1
]

{ #category : #tests }
GameTest >> testWhenTwoShipsTargetTheSameShipAsMercenaryShouldThrowError [

	| aShip aGame someShips someDice cards cardsToDraw aMercenaryCard anotherShip yetAnotherShip anotherCards anotherMercenaryCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	yetAnotherShip := 'test-ship-3'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip
		             with: yetAnotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence:
				              #( 1 1 10 5 19 ) asOrderedCollection)).
	cardsToDraw := OrderedCollection
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new
		               with: MercenaryCard new.
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: cardsToDraw).
	cards := aGame cardsOf: aShip.
	anotherCards := aGame cardsOf: anotherShip.
	aMercenaryCard := cards first.
	anotherMercenaryCard := anotherCards first.

	aGame playCard: aMercenaryCard by: aShip target: yetAnotherShip.
	aGame throwDice. "turno test-ship-1"
	self
		should: [
			aGame
				playCard: anotherMercenaryCard
				by: anotherShip
				target: yetAnotherShip ]
		raise: Error
		withMessage: 'that ship is already a mercenary!'
]

{ #category : #tests }
GameTest >> testWhenUsesARedoCardAfterAPermanentCardAndItsNotTheShipTurnShouldThrowError [

	| aShip aGame someShips someDice aSpeedCard someCardsToDraw anotherCardsToDraw cards aRedoCard anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 1 ) asOrderedCollection)).
	someCardsToDraw := OrderedCollection
		                   with: SpeedCard new
		                   with: RedoCard new
		                   with: SpeedCard new
		                   with: RedoCard new.
	anotherCardsToDraw := OrderedCollection with: RedoCard new.

	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 100
		         wormholeStart: 8
		         wormholeEnd: 9
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 100)
		         deck: (Deck cards: someCardsToDraw).
	cards := aGame cardsOf: aShip.
	aSpeedCard := cards first.
	aRedoCard := cards second.

	aGame playCard: aSpeedCard by: aShip target: aShip.
	aGame throwDice. "turno test-ship-1"
	self
		should: [ aGame playCard: aRedoCard by: aShip target: aShip ]
		raise: Error
		withMessage: 'it is not your turn!'
]

{ #category : #tests }
GameTest >> testWhenUsingACardThatsNotInTheShipDeckThenShouldRaiseError [

	| aShip someShips aGame someDice anotherShip aSpeedCard |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 6 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3
		         lengthInParsecs: 100
		         withNumberOfCards: 100
		         cellGenerator: (FixedCellGenerator allNormalCellsWith: 10).
	aSpeedCard := SpeedCard new.
	self
		should: [ aGame playCard: aSpeedCard by: aShip target: aShip ]
		raise: Error
		withMessage: 'that card is not in deck'
]
