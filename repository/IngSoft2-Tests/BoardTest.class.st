Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BoardTest >> testWhenMoveFromACellOneTimeThenItReturnsTheAdyacentCell [
	| aBoard aCell anotherCell yetAnotherCell|
	aCell := Cell new.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	self assert: (aBoard moveFrom: aCell times: 1) equals: anotherCell.
]

{ #category : #tests }
BoardTest >> testWhenMoveFromACellTwoTimesThenItReturnsTheCellTwoCellsTowards [
	| aBoard aCell anotherCell yetAnotherCell|
	aCell := Cell new.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	self assert: (aBoard moveFrom: aCell times: 2) equals: yetAnotherCell.
]

{ #category : #tests }
BoardTest >> testWhenShipIsInACellThenWhereIsShouldReturnTheCell [
	|aBoard aCell anotherCell yetAnotherCell aShip|
	aShip := Ship withName: 'ship-test-1'.
	aCell := Cell new.
	anotherCell := Cell with: aShip.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	
	self assert: (aBoard whereIs: aShip) equals: anotherCell.
	
	
]

{ #category : #tests }
BoardTest >> testWhenShipIsInAnotherCellThenWhereIsShouldReturnThatCell [
	|aBoard aCell anotherCell yetAnotherCell aShip|
	aShip := Ship withName: 'ship-test-1'.
	aCell := Cell with: aShip.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	
	self assert: (aBoard whereIs: aShip) equals: aCell.
	
	
]

{ #category : #tests }
BoardTest >> testWhenTryToMovesOutsideBoardThenReturnTheLastCell [
	| aBoard aCell anotherCell yetAnotherCell|
	aCell := Cell new.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	self assert: (aBoard moveFrom: aCell times: 10) equals: yetAnotherCell .
]
