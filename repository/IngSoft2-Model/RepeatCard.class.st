Class {
	#name : #RepeatCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card effect' }
RepeatCard >> useWith: aCardManager target: aTargetShip [

	aCardManager repeatLastCellEffectTo: aTargetShip
]
