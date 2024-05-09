Class {
	#name : #Board,
	#superclass : #OrderedCollection,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Board >> moveFrom: aCell times: anAmountOfTimes [ 
	| theCellIndex |
	theCellIndex := ((self indexOf: aCell) + anAmountOfTimes) min: self size.
	^self at: theCellIndex.
]

{ #category : #'as yet unclassified' }
Board >> whereIs: aShip [ 
	^self detect: [ :eachCell | eachCell includes: aShip ] .
]
