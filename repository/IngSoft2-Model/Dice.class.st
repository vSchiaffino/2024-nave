Class {
	#name : #Dice,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Dice class >> withAll: someDice [

	^ self new initializeWith: someDice
]

{ #category : #initialization }
Dice >> initializeWith: someDice [

	dice := someDice
]

{ #category : #'dice logic' }
Dice >> throw [

	^ (dice collect: [ :eachDie | eachDie throw ]) sum
]
