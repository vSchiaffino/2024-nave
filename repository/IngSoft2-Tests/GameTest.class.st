Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
GameTest >> testIfGameIsNotOverThenWinnerShouldThrowError [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-2'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 6 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 3
		         wormholeEnd: 7.
	self
		should: [ aGame winner ]
		raise: Error
		withMessage: 'game is not over yet'
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
		         wormholeStart: 1
		         wormholeEnd: 2.
	aGame playsNextTurn.
	self assert: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenHasTwoLapsAndAShipCompletedTwoLapsShouldBeOver [

	| aShip someShips aGame someDice anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection
		             with: aShip
		             with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 4 3 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         lapsToWin: 2
		         using: someDice
		         withCells: 5
		         wormholeStart: 2
		         wormholeEnd: 3.
	aGame playsNextTurn.
	aGame playsNextTurn.
	aGame playsNextTurn.
	self assert: aGame isOver
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
		         wormholeEnd: 3.
	aGame playsNextTurn.
	self deny: aGame isOver
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
		         wormholeEnd: 5.
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
		         wormholeStart: 3
		         wormholeEnd: 5.
	aGame playsNextTurn.
	self
		should: [ aGame playsNextTurn ]
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
		         lapsToWin: 1
		         using: someDice
		         withCells: 10
		         wormholeStart: 3
		         wormholeEnd: 5.
	aGame playsNextTurn.
	self assert: (aGame indexOfCellWith: aShip) equals: 10

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
		         wormholeEnd: 3.
	aGame playsNextTurn.
	self assert: aGame winner equals: aShip
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
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99.
	aGame playsNextTurn.
	aGame playsNextTurn.

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
		         lapsToWin: 1
		         using: someDice
		         withCells: 100
		         wormholeStart: 98
		         wormholeEnd: 99.
	aGame playsNextTurn.
	aGame playsNextTurn.

	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]
