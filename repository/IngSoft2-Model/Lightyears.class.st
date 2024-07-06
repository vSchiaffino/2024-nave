Class {
	#name : #Lightyears,
	#superclass : #Object,
	#instVars : [
		'amount'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Lightyears class >> amount: anAmount [

	^ self new initializeWith: anAmount
]

{ #category : #initialization }
Lightyears >> initializeWith: anAmount [

	amount := anAmount
]

{ #category : #converting }
Lightyears >> toCellsOf: aBoard [

	| amountInParsecs |
	amountInParsecs := amount // 3.
	^ amountInParsecs // aBoard parsecsPerCell
]
