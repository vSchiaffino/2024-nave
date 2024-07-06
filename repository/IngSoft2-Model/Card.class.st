Class {
	#name : #Card,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
Card >> useWith: aCardManager target: aTargetShipName [

	self subclassResponsibility
]

{ #category : #accessing }
Card >> usedCardWith: lastUsedCard [

	^ self
]
