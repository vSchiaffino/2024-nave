Class {
	#name : #MercenaryShip,
	#superclass : #Ship,
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
MercenaryShip class >> named: aName [

	^ self new initializeWith: aName
]

{ #category : #actions }
MercenaryShip >> beRemoved [

	allies do: [ :eachAlly | eachAlly removeAlly: self ]
]

{ #category : #'as yet unclassified' }
MercenaryShip >> throw: aDice [

	^ aDice throw
]

{ #category : #'as yet unclassified' }
MercenaryShip >> updateLapsIfRequired: aBlockToUpdateLaps [

	
]
