Class {
	#name : #Dice,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Dice class >> withAll: someDice [
	^ (self new ) initializeWith: someDice.
	
]

{ #category : #initialization }
Dice >> initializeWith: someDice [

	dice := someDice
]

{ #category : #'as yet unclassified' }
Dice >> throw [

	^ (dice collect: [ :eachDie | eachDie throw ]) sum
]
