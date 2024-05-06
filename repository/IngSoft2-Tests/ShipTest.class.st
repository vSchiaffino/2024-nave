Class {
	#name : #ShipTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #asserting }
ShipTest >> should: anErrorBlock raise: exceptionClass withMessage: anErrorMessage [
	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : #tests }
ShipTest >> testCanCreateAShipWithName [
	| aShip |
	aShip := Ship withName: 'valen'. 
	self assert: aShip isNotNil 
]

{ #category : #tests }
ShipTest >> testWhenSendNilNameThrowsError [
	| aNilName|
	aNilName := nil.
	self should: [Ship withName: aNilName] raise: Error withMessage: 'cant create a ship with nil name'
]

{ #category : #tests }
ShipTest >> testWhenShipThrowsDiceAndResultIsOneThenOriginCellIsNotOccupiedAndTheAdjacentCellIsOccupied [
	|aBoard aCell anotherCell aShip aOneLoadedDie theDice |
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell new.
	aCell enters: aShip.
	anotherCell := Cell new.
	aOneLoadedDie := LoadedDie in: 1.
	theDice := Dice with: aOneLoadedDie.  
	aBoard := Board with: aCell with: anotherCell.
	
	aShip playIn: aBoard with: theDice.
	
	self deny: aCell isOccupied.
	self assert: anotherCell isOccupied.
]

{ #category : #tests }
ShipTest >> testWhenShipThrowsDiceAndResultIsTwoThenOriginCellIsNotOccupiedAndTheSecondAdyacentCellIsOccupied [
	|aBoard aCell anotherCell yetAnotherCell theDice aShip aTwoLoadedDie |
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell new.
	aCell enters: aShip.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aTwoLoadedDie := LoadedDie in: 2.
	theDice := Dice with: aTwoLoadedDie.  
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	
	aShip playIn: aBoard with: theDice.
	
	self deny: aCell isOccupied.
	self deny: anotherCell isOccupied.
	self assert: yetAnotherCell isOccupied.
]
