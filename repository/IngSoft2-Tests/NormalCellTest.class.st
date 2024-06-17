Class {
	#name : #NormalCellTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
NormalCellTest >> testIfCellHasNoShipThenShouldNotBeOccupied [

	| aCell |
	aCell := NormalCell new.
	self deny: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testIfCellHasTwoShipsAndRemoveShipFromCellThenShouldBeOccupied [

	| aCell aShip anotherShip |
	aCell := NormalCell new.
	aShip := 'test-ship'.
	anotherShip := 'test-ship-2'.
	aCell enters: aShip.
	aCell enters: anotherShip.
	aCell leaves: aShip.
	self assert: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testIfCellHasTwoShipsThenShouldBeOccupied [

	| aCell aShip anotherShip |
	aCell := NormalCell new.
	aShip := 'test-ship'.
	anotherShip := 'test-ship-2'.
	aCell enters: aShip.
	aCell enters: anotherShip.
	self assert: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testIfCreateCellWithAShipThenShouldBeOccupied [

	| aCell aShip |
	aShip := 'test-ship'.
	aCell := NormalCell new.
	aCell enters: aShip.
	self assert: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testIfCreateCellWithTwoShipsThenRemoveOneThenShouldBeOccupied [

	| aCell aShip anotherShip aSetOfShips |
	aSetOfShips := Set new.
	aShip := 'test-ship'.
	anotherShip := 'test-ship-2'.
	aCell := NormalCell new.
	aCell enters: aShip.
	aCell enters: anotherShip.
	aCell leaves: anotherShip.
	self assert: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testIfCreateCellWithTwoShipsThenShouldBeOccupied [

	| aCell aShip anotherShip |
	aShip := 'test-ship'.
	anotherShip := 'test-ship-2'.
	aCell := NormalCell new.
	aCell enters: aShip.
	aCell enters: anotherShip.
	self assert: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testIfRemoveShipFromCellThenShouldNotBeOccupied [

	| aCell aShip |
	aCell := NormalCell new.
	aShip := 'test-ship'.
	aCell enters: aShip.
	aCell leaves: aShip.
	self deny: aCell isOccupied
]

{ #category : #tests }
NormalCellTest >> testWhenCellHasAShipThenShouldIncludeThatShip [

	| aShip aCell |
	aShip := 'test-name-1'.
	aCell := NormalCell new.
	aCell enters: aShip.

	self assert: (aCell includes: aShip)
]

{ #category : #tests }
NormalCellTest >> testWhenCellHasNoShipThenShouldNotIncludeAShip [

	| aShip aCell |
	aShip := 'test-name-1'.
	aCell := NormalCell new.

	self deny: (aCell includes: aShip)
]

{ #category : #tests }
NormalCellTest >> testWhenShipEntersToABlackholeCellThenLandsInAOccupiedCellThenTheLoserShipShouldMoveToTheBeginning [

	| aShip someShips aGame someDice someCells anotherShip |
	aShip := 'test-ship-1'.
	anotherShip := 'test-ship-2'.
	someShips := OrderedCollection with: aShip with: anotherShip.
	someDice := Dice withAll:
		            (Set with:
			             (LoadedDie sequence: #( 2 6 10 5 ) asOrderedCollection)).
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
		         wormholeStart: 4
		         wormholeEnd: 5
		         lengthInParsecs: 100
		         cellGenerator: (FixedCellGenerator cells: someCells).
	aGame playsNextTurn.
	aGame playsNextTurn.

	self assert: (aGame indexOfCellWith: aShip) equals: 3.
	self assert: (aGame indexOfCellWith: anotherShip) equals: 1
]

{ #category : #tests }
NormalCellTest >> testWhenSpaceshipIsInTheCellItIncludesThatSpaceShip [

	| aCell aShip |
	aShip := 'test-ship-1'.
	aCell := NormalCell new.
	aCell enters: aShip.

	self assert: (aCell includes: aShip)
]
