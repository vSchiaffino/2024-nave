Class {
	#name : #Cell,
	#superclass : #Object,
	#instVars : [
		'ships'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Cell >> enters: aShip [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Cell >> entersAll: someShips [

	someShips do: [ :eachShip | self enters: eachShip ]
]

{ #category : #testing }
Cell >> includes: aShip [

	^ ships includes: aShip
]

{ #category : #initialization }
Cell >> initialize [

	ships := OrderedCollection new
]

{ #category : #'as yet unclassified' }
Cell >> isOccupied [

	^ ships notEmpty
]

{ #category : #'as yet unclassified' }
Cell >> leaves: aShip [

	ships remove: aShip
]
