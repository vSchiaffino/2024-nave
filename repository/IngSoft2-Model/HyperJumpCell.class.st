Class {
	#name : #HyperJumpCell,
	#superclass : #Cell,
	#instVars : [
		'lengths'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperJumpCell class >> withLengths: aCollectionOfLenghts [

	^ self new initializeWith: aCollectionOfLenghts
]

{ #category : #'as yet unclassified' }
HyperJumpCell >> applyEffectTo: aShip in: aBoard [

	| anAmountToMove |
	anAmountToMove := lengths first.
	lengths removeFirst.
	lengths addLast: anAmountToMove.
	aBoard move: aShip by: anAmountToMove
]

{ #category : #initialization }
HyperJumpCell >> initializeWith: someLengths [

	lengths := someLengths.
	^ self
]
