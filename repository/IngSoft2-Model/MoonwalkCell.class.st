Class {
	#name : #MoonwalkCell,
	#superclass : #Cell,
	#instVars : [
		'times'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
MoonwalkCell class >> times: aNumberOfTimes [

	^ self new initializeWith: aNumberOfTimes
]

{ #category : #'as yet unclassified' }
MoonwalkCell >> applyEffectTo: aShip in: aBoard [
	aBoard moveAllShips: times negated except: aShip.
]

{ #category : #initialization }
MoonwalkCell >> initializeWith: aNumberOfTimes [ 
	times := aNumberOfTimes.
]
