Class {
	#name : #DiceTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DiceTest >> testWhenCreateDiceWithThreeLoadedDieAndSixLoadedDieItThrowsNine [

	| aThreeLoadedDie aSixLoadedDie aDice someDice |
	aThreeLoadedDie := LoadedDie sequence: #( 3 ) asOrderedCollection.
	aSixLoadedDie := LoadedDie sequence: #( 6 ) asOrderedCollection.
	someDice := Set with: aThreeLoadedDie with: aSixLoadedDie.
	aDice := Dice withAll: someDice.
	self assert: aDice throw equals: 9
]

{ #category : #tests }
DiceTest >> testWhenCreateDiceWithTwoLoadedDieThrowsTwo [

	| aTwoLoadedDie aDice someDice |
	aTwoLoadedDie := LoadedDie sequence: #( 2 ) asOrderedCollection.
	someDice := Set with: aTwoLoadedDie.
	aDice := Dice withAll: someDice.
	self assert: aDice throw equals: 2
]
