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

{ #category : #initialization }
FixedBoard class >> initializeWithAllNormalCells: length lengthInParsecs: aLengthInParsecs [

	^ self new
		  initializeWithAllNormalCells: length
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

{ #category : #initialization }
FixedBoard >> initializeWithAllNormalCells: length lengthInParsecs: aLengthInParsecs [
	lengthInParsecs := aLengthInParsecs.
	cells := OrderedCollection new.
	1 to: length do: [ :index | cells add: NormalCell new ].
	^ self
]
