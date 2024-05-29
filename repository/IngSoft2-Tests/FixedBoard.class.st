Class {
	#name : #FixedBoard,
	#superclass : #Board,
	#category : #'IngSoft2-Tests'
}

{ #category : #initialization }
FixedBoard class >> initializeWith: someCells lengthInParsecs: aLengthInParsecs [

	^ self new
		  initializeWith: someCells
		  lengthInParsecs: aLengthInParsecs
]

{ #category : #'as yet unclassified' }
FixedBoard class >> withCells: someCells [
	^ (self new) initializeWith: someCells
]

{ #category : #initialization }
FixedBoard >> initializeWith: someCells lengthInParsecs: aLengthInParsecs [
	lengthInParsecs := aLengthInParsecs.
	cells := someCells
]
