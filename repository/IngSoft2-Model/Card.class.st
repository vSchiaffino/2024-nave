Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'originalCard'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Card class >> new [

	^ self basicNew initialize
]

{ #category : #'instance creation' }
Card class >> newWithOriginalCard: anOriginalCard [

	^ self basicNew initializeWithOriginalCard: anOriginalCard
]

{ #category : #initialization }
Card >> initialize [

	self initializeWithOriginalCard: self
]

{ #category : #initialization }
Card >> initializeWithOriginalCard: anOriginalCard [

	originalCard := anOriginalCard
]

{ #category : #'card effect' }
Card >> useWith: aCardManager target: aTargetShipName [

	self subclassResponsibility
]

{ #category : #accessing }
Card >> usedCardWith: lastUsedCard [

	^ self
]
