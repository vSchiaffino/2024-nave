Class {
	#name : #LoadedDieTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
LoadedDieTest >> testWhenSequenceIsOnlyFiveItThrowsFiveEverytime [
	|aLoadedDieInFive|
	aLoadedDieInFive := LoadedDie sequence: #(5) asOrderedCollection.
	self assert:  (aLoadedDieInFive throw) equals: 5.
]

{ #category : #tests }
LoadedDieTest >> testWhenSequenceIsOnlySixItThrowsSixEverytime [
	|aLoadedDieInFive|
	aLoadedDieInFive := LoadedDie sequence: #(6) asOrderedCollection.
	self assert:  (aLoadedDieInFive throw) equals: 6.
]

{ #category : #tests }
LoadedDieTest >> testWhenSequenceIsTwoFourFiveItFollowTheSequence [
	|aLoadedDie |
	aLoadedDie := LoadedDie sequence: #(2 4 5) asOrderedCollection.
	self assert:  (aLoadedDie throw) equals: 2.
	self assert:  (aLoadedDie throw) equals: 4.
	self assert:  (aLoadedDie throw) equals: 5.
]
