Class {
	#name : #SpaceshipGameWithFixedBoard,
	#superclass : #SpaceshipGame,
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
SpaceshipGameWithFixedBoard class >> with: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: someCells [

	^ self new
		  initializeWith: someShipNames
		  lapsToWin: aNumberOfLapsToWin
		  using: someDice
		  withCells: someCells
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
