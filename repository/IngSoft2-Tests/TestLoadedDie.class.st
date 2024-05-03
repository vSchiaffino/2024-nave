Class {
	#name : #TestLoadedDie,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
TestLoadedDie >> testWhenLoadedFaceIsFiveItThrowsFive [
	|aLoadedDieInFive|
	aLoadedDieInFive := LoadedDie in: 5.
	self assert:  (aLoadedDieInFive throw) equals: 5.
]

{ #category : #tests }
TestLoadedDie >> testWhenLoadedFaceIsSixItThrowsSix [
	|aLoadedDieInSix|
	aLoadedDieInSix := LoadedDie in: 6.
	self assert:  (aLoadedDieInSix throw) equals: 6.
]
