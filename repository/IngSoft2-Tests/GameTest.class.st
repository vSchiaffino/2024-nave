Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #asserting }
GameTest >> should: anErrorBlock raise: exceptionClass withMessage: anErrorMessage [
	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : #tests }
GameTest >> testIfGameIsNotOverThenWinnerShouldThrowError [
	| aCell anotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell with: aShip.
	anotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip) asOrderedCollection.
	self should: [aGame winner] raise: Error withMessage: 'game is not over yet'.

]

{ #category : #tests }
GameTest >> testWhenBoardHasAShipInTheLastCellAndAShipInTheFirstCellThenWinnerShouldReturnTheShipInTheLastCell [
	| aCell anotherCell aBoard aDice aShip aGame anotherShip |
	aShip := Ship withName: 'test-ship-1'.
	anotherShip := Ship withName: 'test-ship-2'.
	aCell := Cell with: aShip.
	anotherCell := Cell with: anotherShip.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip anotherShip) asOrderedCollection .
	self assert: (aGame winner) equals: anotherShip.

]

{ #category : #tests }
GameTest >> testWhenBoardHasAShipInTheLastCellThenWinnerShouldReturnThatShip [
	| aCell anotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell new.
	anotherCell := Cell with: aShip.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip) asOrderedCollection.
	self assert: (aGame winner) equals: aShip.

]

{ #category : #tests }
GameTest >> testWhenBoardHaveThreeCellsAndShipIsInTheSecondCellThenIsOverShouldReturnFalse [
	| aCell anotherCell yetAnotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell new.
	anotherCell := Cell with: aShip.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing:  #(aShip) asOrderedCollection.
	self deny: aGame isOver.

]

{ #category : #tests }
GameTest >> testWhenBoardHaveTwoCellsAndShipIsInTheFirstCellThenIsOverShouldReturnFalse [
	| aCell anotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell with: aShip.
	anotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing:#(aShip) asOrderedCollection.
	self deny: aGame isOver.

]

{ #category : #tests }
GameTest >> testWhenBoardHaveTwoCellsAndShipIsInTheSecondCellThenIsOverShouldReturnTrue [
	| aCell anotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell new.
	anotherCell := Cell with: aShip.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip) asOrderedCollection.
	self assert: aGame isOver.

]

{ #category : #tests }
GameTest >> testWhenGamePlayedOneTurnThenNextToPlayIsTheSecondInTheList [
	| aCell anotherCell aBoard aDice aShip aGame anotherShip yetAnotherCell aShipCollection |
	aShip := Ship withName: 'test-ship-1'.
	anotherShip := Ship withName: 'test-ship-2'.
	aCell := Cell with: aShip with: anotherShip.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	aDice := Dice with: (Die of: 6).
	aShipCollection := OrderedCollection with: aShip with: anotherShip.
	aGame := Game in: aBoard with: aDice playing: aShipCollection.
	aGame playsNextTurn.
	
	self assert: (aGame nextToPlay) equals: anotherShip.

]

{ #category : #tests }
GameTest >> testWhenGameStartedThenFirstPlayerToPlayIsTheFirstInTheList [
	| aCell anotherCell aBoard aDice aShip aGame anotherShip yetAnotherCell aShipCollection |
	aShip := Ship withName: 'test-ship-1'.
	anotherShip := Ship withName: 'test-ship-2'.
	aCell := Cell with: aShip with: anotherShip.
	anotherCell := Cell new.
	yetAnotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell with: yetAnotherCell.
	aDice := Dice with: (Die of: 6).
	aShipCollection := OrderedCollection with: aShip with: anotherShip.
	aGame := Game in: aBoard with: aDice playing: aShipCollection.
	
	self assert: (aGame nextToPlay) equals: aShip.

]

{ #category : #tests }
GameTest >> testWhenShipIsInFirstCellThenWhereIsShipShouldReturnTheFirstCell [
	| aCell anotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell with: aShip.
	anotherCell := Cell new.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip) asOrderedCollection.
	
	self assert: (aGame whereIs: aShip) equals: aCell.

]

{ #category : #tests }
GameTest >> testWhenShipIsInLastCellThenPlaysNextTurnShouldThrowError [
	| aCell anotherCell aBoard aDice aShip aGame anotherShip |
	aShip := Ship withName: 'test-ship-1'.
	anotherShip := Ship withName: 'test-ship-2'.
	aCell := Cell with: anotherShip.
	anotherCell := Cell with: aShip.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip anotherShip) asOrderedCollection.
	self should: [aGame playsNextTurn] raise: Error withMessage: 'game is over!'
]

{ #category : #tests }
GameTest >> testWhenShipIsInLastCellThenWhereIsShipShouldReturnTheLastCell [
	| aCell anotherCell aBoard aDice aShip aGame|
	aShip := Ship withName: 'test-ship-1'.
	aCell := Cell new.
	anotherCell := Cell with: aShip.
	aBoard := Board with: aCell with: anotherCell.
	aDice := Dice with: (Die of: 6).
	aGame := Game in: aBoard with: aDice playing: #(aShip) asOrderedCollection.
	
	self assert: (aGame whereIs: aShip) equals: anotherCell.

]
