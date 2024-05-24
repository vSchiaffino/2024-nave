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
NormalCellTest >> testWhenCellHasAShipThenShouldNotIncludeAnotherShip [

	| aShip aCell anotherShip |
	aShip := 'test-name-1'.
	anotherShip := 'test-name-2'.
	aCell := NormalCell new.
	aCell enters: aShip.

	self deny: (aCell includes: anotherShip)
]

{ #category : #tests }
NormalCellTest >> testWhenCellHasNoShipThenShouldNotIncludeAShip [

	| aShip aCell |
	aShip := 'test-name-1'.
	aCell := NormalCell new.

	self deny: (aCell includes: aShip)
]

{ #category : #tests }
NormalCellTest >> testWhenSpaceshipIsInTheCellItIncludesThatSpaceShip [

	| aCell aShip |
	aShip := 'test-ship-1'.
	aCell := NormalCell new.
	aCell enters: aShip.

	self assert: (aCell includes: aShip)
]
