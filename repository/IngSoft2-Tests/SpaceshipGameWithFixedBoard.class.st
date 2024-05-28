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

{ #category : #initialization }
SpaceshipGameWithFixedBoard >> initializeWith: someShipNames lapsToWin: aNumberOfLapsToWin using: someDice withCells: someCells [

	lapsToWin := aNumberOfLapsToWin.
	dice := someDice.
	ships := someShipNames collect: [ :eachShipName |
		         Ship named: eachShipName ].
	board := FixedBoard withCells: someCells.
	board at: 1 place: ships.
	^ self
]
