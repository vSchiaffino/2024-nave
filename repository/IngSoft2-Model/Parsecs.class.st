Class {
	#name : #Parsecs,
	#superclass : #Object,
	#instVars : [
		'amount'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Parsecs class >> amount: anAmount [

	^ self new initializeWith: anAmount
]

{ #category : #initialization }
Parsecs >> initializeWith: anAmount [

	amount := anAmount
]

{ #category : #converting }
Parsecs >> toCellsOf: aBoard [

	^ amount // aBoard parsecsPerCell
]
