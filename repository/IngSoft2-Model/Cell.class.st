Class {
	#name : #Cell,
	#superclass : #Object,
	#instVars : [
		'ships'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'cell effect' }
Cell >> applyEffectTo: aShip in: aBoard [

	self subclassResponsibility
]

{ #category : #'ship collision' }
Cell >> checkCollisionIn: aGame [

	ships size = 2 ifTrue: [
		aGame handleCollisionBetween: (ships at: 1) and: (ships at: 2) ]
]

{ #category : #accessing }
Cell >> enters: aShip [

	ships add: aShip
]

{ #category : #accessing }
Cell >> entersAll: someShips [

	someShips do: [ :eachShip | self enters: eachShip ]
]

{ #category : #accessing }
Cell >> includes: aShip [

	^ ships includes: aShip
]

{ #category : #initialization }
Cell >> initialize [

	ships := OrderedCollection new
]

{ #category : #accessing }
Cell >> isOccupied [

	^ ships notEmpty
]

{ #category : #accessing }
Cell >> leaves: aShip [

	ships remove: aShip
]
