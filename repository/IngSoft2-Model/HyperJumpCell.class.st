Class {
	#name : #HyperJumpCell,
	#superclass : #Cell,
	#instVars : [
		'lengths'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
HyperJumpCell class >> withLengths: aCollectionOfLenghts [

	^ self new initializeWith: aCollectionOfLenghts
]

{ #category : #'cell effect' }
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
