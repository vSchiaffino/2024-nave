Class {
	#name : #FixedBoard,
	#superclass : #Board,
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
FixedBoard class >> withCells: someCells [
	^ (self new) initializeWith: someCells
]

{ #category : #initialization }
FixedBoard >> initializeWith: someCells [ 
	cells := someCells
]
