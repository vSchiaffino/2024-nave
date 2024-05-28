Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'name',
		'laps',
		'shields',
		'penalty'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Ship class >> named: aName [

	^ self new initializeWith: aName
]

{ #category : #adding }
Ship >> addLaps: aNumberOfLaps [

	laps := laps + aNumberOfLaps
]

{ #category : #'as yet unclassified' }
Ship >> applyTurnPenaltyElse: aBlockIfNotPenalized [

	penalty > 0
		ifTrue: [
			penalty = 2 ifTrue: [ shields := 3 ].
			penalty := penalty - 1 ]
		ifFalse: [ aBlockIfNotPenalized value ]
]

{ #category : #initialization }
Ship >> initializeWith: aName [

	name := aName.
	laps := 0.
	shields := 3.
	penalty := 0.
	^ self
]

{ #category : #'as yet unclassified' }
Ship >> lapsCompleted [

	^ laps
]

{ #category : #accessing }
Ship >> name [

	^ name
]

{ #category : #removing }
Ship >> removeShield [

	shields := shields - 1.
	shields = 0 ifTrue: [ penalty := 2 ]
]

{ #category : #'as yet unclassified' }
Ship >> restoreShields [
	shields := 3
]
