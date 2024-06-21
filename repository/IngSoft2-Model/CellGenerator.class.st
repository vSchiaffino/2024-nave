Class {
	#name : #CellGenerator,
	#superclass : #Object,
	#instVars : [
		'numberOfCells',
		'cellProbabilities'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
CellGenerator class >> length: aNumberOfCells probabilites: someProbabilities [

	self verifyAreValid: someProbabilities.
	^ self new
		  initializeWith: aNumberOfCells
		  probabilities: someProbabilities
]

{ #category : #initialization }
CellGenerator class >> verifyAreValid: someProbabilities [

	| probabilitiesSum |
	probabilitiesSum := (someProbabilities collect: [ :eachProbability |
		                     eachProbability first ]) sum.
	probabilitiesSum ~= 1 ifTrue: [
		Error signal: 'probabilities should sum one in total' ]
]

{ #category : #translating }
CellGenerator >> generate [

	| cells random seed |
	seed := Random new.
	cells := OrderedCollection new.
	1 to: numberOfCells do: [ :index |
		random := seed next.
		cellProbabilities do: [ :eachCellProbability |
			eachCellProbability addCellTo: cells ifIsInRange: random ] ].
	^ cells
]

{ #category : #initialization }
CellGenerator >> initializeWith: aNumberOfCells probabilities: someProbabilities [

	| rangeAcummulator aCellCreation cellRate aRangeStart |
	rangeAcummulator := 0.
	numberOfCells := aNumberOfCells.
	cellProbabilities := someProbabilities collect: [ :eachProbability |
		                     cellRate := eachProbability first.
		                     aCellCreation := eachProbability second.
		                     aRangeStart := rangeAcummulator.
		                     rangeAcummulator := rangeAcummulator + cellRate.

		                     CellProbability
			                     cellCreation: aCellCreation
			                     rangeStart: aRangeStart
			                     rangeEnd: rangeAcummulator ].
	^ self
]
