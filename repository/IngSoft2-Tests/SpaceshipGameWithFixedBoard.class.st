Class {
	#name : #SpaceshipGameWithFixedBoard,
	#superclass : #SpaceshipGame,
	#category : #'IngSoft2-Tests'
}

{ #category : #initialization }
SpaceshipGameWithFixedBoard class >> initializeWithAllNormalCells: aBoardLength ships: someShipNames lapsToWin: anAmountOfLapsToWin using: someDice lengthInParsecs: aLengthInParsecs [

	^ self new
		  initializeWithAllNormalCells: aBoardLength
		  ships: someShipNames
		  lapsToWin: anAmountOfLapsToWin
		  using: someDice
		  lengthInParsecs: aLengthInParsecs
]

{ #category : #'as yet unclassified' }
SpaceshipGameWithFixedBoard class >> with: someShipNames lapsToWin: anAmountOfLapsToWin using: someDice withCells: someCells lengthInParsecs: aLengthInParsecs [ 
	^(self new) initializeWith: someShipNames lapsToWin: anAmountOfLapsToWin using: someDice  withCells: someCells lengthInParsecs: aLengthInParsecs
]

{ #category : #initialization }
SpaceshipGameWithFixedBoard >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: someCells lengthInParsecs: aLengthInParsecs [

	lapsToWin := aNumberOfLapsToWin.
	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship named: eachShipName ].
	board := FixedBoard
		         initializeWith: someCells
		         lengthInParsecs: aLengthInParsecs.
	board at: 1 place: ships.
	^ self
]

{ #category : #initialization }
SpaceshipGameWithFixedBoard >> initializeWithAllNormalCells: length ships: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice lengthInParsecs: aLengthInParsecs [

	lapsToWin := aNumberOfLapsToWin.
	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship named: eachShipName ].
	board := FixedBoard
		         initializeWithAllNormalCells: length
		         lengthInParsecs: aLengthInParsecs.
	board at: 1 place: ships.
	^ self
]
