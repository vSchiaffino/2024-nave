Class {
	#name : #CellGeneratorTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
CellGeneratorTest >> testWhenHaveTwoTypesOfCellShouldGenerateDesiredNumbersOfCells [

	| probabilites aCellGenerator cells |
	probabilites := OrderedCollection with: {
			                0.5.
			                [ NormalCell new ]} with: {0.5.[HyperSpaceJumpCell new]}.
	aCellGenerator := CellGenerator length: 20 probabilites: probabilites.
	cells := aCellGenerator generate.

	self assert: cells size equals: 20.
]

{ #category : #tests }
CellGeneratorTest >> testWhenNormalCellProbabilitieIsOneAndLengthTwentyThenShouldGenerateTwentyNormalCells [

	| probabilites aCellGenerator cells |
	probabilites := OrderedCollection with: {
			                1.
			                [ NormalCell new ] }.
	aCellGenerator := CellGenerator length: 20 probabilites: probabilites.
	cells := aCellGenerator generate.

	self assert: cells size equals: 20.
	cells do: [ :eachCell | self assert: (eachCell isKindOf: NormalCell) ]
]

{ #category : #tests }
CellGeneratorTest >> testWhenProbabilitiesDontSumOneInTotalShouldThrow [

	| probabilites |
	probabilites := OrderedCollection with: {
			                0.5.
			                [ NormalCell new ] }.
	self
		should: [ CellGenerator length: 20 probabilites: probabilites ]
		raise: Error
		withMessage: 'probabilities should sum one in total'
]
