Class {
	#name : #ShieldManager,
	#superclass : #Object,
	#instVars : [
		'max',
		'actual'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'shields logic' }
ShieldManager >> addShield [

	actual = max
		ifTrue: [ max := max + 1 ]
		ifFalse: [ actual := actual + 1 ]
]

{ #category : #initialization }
ShieldManager >> initialize [

	max := 3.
	actual := 3
]

{ #category : #'shields logic' }
ShieldManager >> loseShieldAs: aShip [

	actual := actual - 1.
	actual = 0 ifTrue: [ aShip startPenalty ]
]

{ #category : #'shields logic' }
ShieldManager >> restoreShields [

	actual := max
]
