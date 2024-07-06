Class {
	#name : #MercenaryEffect,
	#superclass : #CardEffect,
	#instVars : [
		'toShip',
		'fromShip'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
MercenaryEffect class >> createdBy: aCard from: fromShip to: toShip [

	^ self new initializeWith: aCard from: fromShip to: toShip
]

{ #category : #initialization }
MercenaryEffect >> initializeWith: aCreatedBy from: aFromShip to: aToShip [

	createdBy := aCreatedBy.
	fromShip := aFromShip.
	toShip := aToShip.
	^ self
]

{ #category : #'helper methods' }
MercenaryEffect >> is: aShip alliedWith: anotherShip [

	^ (self is: aShip mercenaryOf: anotherShip) or:
		  (self is: anotherShip  mercenaryOf: aShip )
]

{ #category : #'helper methods' }
MercenaryEffect >> is: aShip mercenaryOf: anotherShip [

	^ (toShip = anotherShip and: fromShip = aShip)
]

{ #category : #'helper methods' }
MercenaryEffect >> mercenaryCollideWith: possibleMercenaryName [

	^ possibleMercenaryName = toShip name
]
