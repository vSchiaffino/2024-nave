Class {
	#name : #LoadedDieTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
LoadedDieTest >> testWhenLoadedFaceIsFiveItThrowsFive [
	|aLoadedDieInFive|
	aLoadedDieInFive := LoadedDie in: 5.
	self assert:  (aLoadedDieInFive throw) equals: 5.
]

{ #category : #tests }
LoadedDieTest >> testWhenLoadedFaceIsSixItThrowsSix [
	|aLoadedDieInSix|
	aLoadedDieInSix := LoadedDie in: 6.
	self assert:  (aLoadedDieInSix throw) equals: 6.
]
