Class {
	#name : #TestDice,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
TestDice >> testWhenCreateDiceWithThreeLoadedDieAndSixLoadedDieItThrowsNine [
	| aThreeLoadedDie aSixLoadedDie aDice |
	aThreeLoadedDie := LoadedDie in: 3.
	aSixLoadedDie := LoadedDie in: 6.
	aDice := Dice with: aThreeLoadedDie with: aSixLoadedDie.
	self assert: aDice throw equals: 9.	
]

{ #category : #tests }
TestDice >> testWhenCreateDiceWithTwoLoadedDieThrowsTwo [
	| aTwoLoadedDie aDice |
	aTwoLoadedDie  := LoadedDie in: 2.
	aDice := Dice with: aTwoLoadedDie.
	self assert: aDice throw equals: 2.
]
