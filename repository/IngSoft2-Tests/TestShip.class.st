Class {
	#name : #TestShip,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #asserting }
TestShip >> should: anErrorBlock raise: exceptionClass withMessage: anErrorMessage [
	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]

{ #category : #tests }
TestShip >> testCanCreateAShipWithName [
	| aShip |
	aShip := Ship withName: 'valen'. 
	self assert: aShip isNotNil 
]

{ #category : #tests }
TestShip >> testWhenSendNilNameThrowsError [
	| aNilName|
	aNilName := nil.
	self should: [Ship withName: aNilName] raise: Error withMessage: 'cant create a ship with nil name'
]
