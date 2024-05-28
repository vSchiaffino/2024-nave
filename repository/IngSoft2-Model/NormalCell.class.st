Class {
	#name : #NormalCell,
	#superclass : #Cell,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
NormalCell >> applyEffectTo: aShip in: aBoard [
	
]

{ #category : #'as yet unclassified' }
NormalCell >> enters: aShip [

	ships add: aShip
]
