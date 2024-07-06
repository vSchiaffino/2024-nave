Class {
	#name : #RedoCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
RedoCard >> useWith: aCardManager target: aTarget [

	aCardManager repeatLastCardWithTarget: aTarget
]

{ #category : #accessing }
RedoCard >> usedCardWith: lastUsedCard [

	^ lastUsedCard
]
