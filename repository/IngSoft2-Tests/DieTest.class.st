Class {
	#name : #DieTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DieTest >> should: anErrorBlock raise: exceptionClass withMessage: anErrorMessage [
	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : #tests }
DieTest >> testErrorWhenCreateATwoFacedDie [
	self should: [ Die of: 2 ] raise: Error withMessage: 'number of faces must be greater than two'.
]

{ #category : #tests }
DieTest >> testWhenThrowFourFacedDieReturnsBetweenOneAndFour [
	| aDie |
	aDie := Die of: 4.	
	self assert: (aDie throw between: 1 and: 4).
]
