Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'name',
		'laps'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Ship class >> named: aName [ 
	^(self new ) initializeWith: aName.
]

{ #category : #adding }
Ship >> addLaps: aNumberOfLaps [ 
	laps := laps + aNumberOfLaps 
]

{ #category : #initialization }
Ship >> initializeWith: aName [

	name := aName.
	laps := 0.
	^ self
]

{ #category : #'as yet unclassified' }
Ship >> lapsCompleted [
	^laps
]

{ #category : #accessing }
Ship >> name [
	^name.
]
