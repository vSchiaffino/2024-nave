Class {
	#name : #FixedCellGenerator,
	#superclass : #Object,
	#instVars : [
		'cellsToGenerate'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
FixedCellGenerator class >> allNormalCellsWith: aNormalCellLength [

	| cells |
	cells := OrderedCollection new.
	1 to: aNormalCellLength do: [ :index | cells add: NormalCell new ].
	^ self cells: cells
]

{ #category : #'as yet unclassified' }
FixedCellGenerator class >> cells: someCellsToGenerate [

	^ self new initializeWith: someCellsToGenerate
]

{ #category : #translating }
FixedCellGenerator >> generate [

	^ cellsToGenerate
]

{ #category : #initialization }
FixedCellGenerator >> initializeWith: someCells [

	cellsToGenerate := someCells.
	^ self
]
