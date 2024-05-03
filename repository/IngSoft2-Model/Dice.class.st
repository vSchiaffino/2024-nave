Class {
	#name : #Dice,
	#superclass : #Array,
	#type : #variable,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Dice >> throw [
	^ (self collect: [:eachDie | eachDie throw]) sum.
]
