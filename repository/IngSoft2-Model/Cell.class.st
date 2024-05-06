Class {
	#name : #Cell,
	#superclass : #Set,
	#category : #'IngSoft2-Model'
}

{ #category : #testing }
Cell >> enters: aShip [
	self add: aShip.
]

{ #category : #testing }
Cell >> isOccupied [
	^self notEmpty.
]

{ #category : #testing }
Cell >> leaves: aShip [
	self remove: aShip.
]
