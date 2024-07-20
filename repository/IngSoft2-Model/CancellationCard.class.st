Class {
	#name : #CancellationCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
CancellationCard >> useWith: aCardManager target: aTargetCard [

	aCardManager removeEffectOf: aTargetCard.
	aCardManager discard: aTargetCard.
	aCardManager discard: originalCard
]
