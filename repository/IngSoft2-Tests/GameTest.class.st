Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}
{ #category : #tests }
GameTest >> testIfGameIsNotOverThenWinnerShouldThrowError [

	| someShips aGame someDice |
	someShips := OrderedCollection
		             with: 'test-name-1'
		             with: 'test-name-2'.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 6 )) asOrderedCollection).
	aGame := SpaceshipGame
		         with: someShips
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
GameTest >> testWhenBoardHaveFiveCellsAndShipIsInTheFifthCellThenShouldBeOver [

	| aShip aGame someDice someShips |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 5 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         using: someDice
		         withCells: 5
		         wormholeStart: 1
		         wormholeEnd: 2.
	aGame playsNextTurn.
	self assert: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenBoardHaveFourCellsAndShipIsInTheFirstCellThenShouldNotBeOver [

	| aShip aGame someDice someShips |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 1 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips 
		         using: someDice
		         withCells: 4
		         wormholeStart: 2
		         wormholeEnd: 3.
	self deny: aGame isOver
]

{ #category : #tests }
GameTest >> testWhenBoardHaveTenCellsAndDiceThrowsTenThenTheWinnerShouldBeFirstPlayer [

	| aShip anotherShip someShips someDice aGame |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         using: someDice
		         withCells: 10
		         wormholeStart: 2
		         wormholeEnd: 3.
	aGame playsNextTurn.
	self assert: aGame winner equals: aShip
]

{ #category : #'as yet unclassified' }
GameTest >> testWhenBoardHaveTenCellsAndShipIsInTheSecondCellThenShouldNotBeOver [

	| aShip aGame someShips someDice |
	aShip := 'test-ship-1'.
	someShips := OrderedCollection with: aShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         using: someDice
		         withCells: 10
		         wormholeStart: 3
		         wormholeEnd: 5.
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
			             (LoadedDie sequence: #( 10 ) asOrderedCollection)).
	aGame := SpaceshipGame
		         with: someShips
		         using: someDice
		         withCells: 10
		         wormholeStart: 3
		         wormholeEnd: 5.
	aGame playsNextTurn.
	self assert: (aGame indexOfCellWith: aShip) equals: 10

]
