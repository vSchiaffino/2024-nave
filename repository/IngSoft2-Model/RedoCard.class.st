Class {
	#name : #RedoCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
RedoCard >> useWith: aCardManager target: aTarget [

	aCardManager repeatLastCardWithTarget: aTarget by: originalCard
]

{ #category : #accessing }
RedoCard >> usedCardWith: lastUsedCard [

	^ lastUsedCard
]
