Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'shields',
		'penalty',
		'name',
		'allies'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Ship >> addAlly: anAlly [

	allies add: anAlly
]

{ #category : #accessing }
Ship >> allies [

	^ allies
]

{ #category : #'as yet unclassified' }
Ship >> applyTurnPenaltyElse: aBlockIfNotPenalized [

	penalty > 0
		ifTrue: [
			penalty = 2 ifTrue: [ shields := 3 ].
			penalty := penalty - 1 ]
		ifFalse: [ aBlockIfNotPenalized value ]
]

{ #category : #'as yet unclassified' }
Ship >> ifIsNotAlly: aShip do: aBlockIfNotAlly [

	(allies includes: aShip) ifFalse: [ aBlockIfNotAlly value ]
]

{ #category : #initialization }
Ship >> initializeWith: aName [

	allies := OrderedCollection new.
	name := aName.
	shields := 3.
	penalty := 0.
	^ self
]

{ #category : #accessing }
Ship >> name [

	^ name
]

{ #category : #removing }
Ship >> removeAlly: aMercenaryShip [

	allies remove: aMercenaryShip ifAbsent: [  ]
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
