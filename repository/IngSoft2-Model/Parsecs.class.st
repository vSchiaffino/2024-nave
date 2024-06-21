Class {
	#name : #Parsecs,
	#superclass : #Object,
	#instVars : [
		'amount'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Parsecs class >> amount: anAmount [

	^ self new initializeWith: anAmount
]

{ #category : #initialization }
Parsecs >> initializeWith: anAmount [

	amount := anAmount
]

{ #category : #'as yet unclassified' }
Parsecs >> toCellsOf: aBoard [

	^ amount // aBoard parsecsPerCell
]
