Class {
	#name : #Lightyears,
	#superclass : #Object,
	#instVars : [
		'amount'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Lightyears class >> amount: anAmount [

	^ self new initializeWith: anAmount
]

{ #category : #initialization }
Lightyears >> initializeWith: anAmount [

	amount := anAmount
]

{ #category : #'as yet unclassified' }
Lightyears >> toCellsOf: aBoard [

	| amountInParsecs |
	amountInParsecs := amount // 3.
	^ amountInParsecs // aBoard parsecsPerCell
]
