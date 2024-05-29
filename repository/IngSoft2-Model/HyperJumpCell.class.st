Class {
	#name : #HyperJumpCell,
	#superclass : #Cell,
	#instVars : [
		'parsecs'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperJumpCell class >> withParsecs: someParsecs [ 
	^ self new initializeWith: someParsecs.
]

{ #category : #'as yet unclassified' }
HyperJumpCell >> applyEffectTo: aShip in: aBoard [

	| aParsecAmount |
	aParsecAmount := parsecs first.
	parsecs removeFirst.
	parsecs addLast: aParsecAmount.
	aBoard move: aShip byParsecs: aParsecAmount
]

{ #category : #initialization }
HyperJumpCell >> initializeWith: someParsecs [ 
	parsecs := someParsecs.
	^self
]
