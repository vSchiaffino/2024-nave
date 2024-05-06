Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Ship class >> verifyIsNotNil: aName [

	aName ifNil: [ Error signal: 'cant create a ship with nil name' ]
]

{ #category : #'as yet unclassified' }
Ship class >> withName: aName [
	self verifyIsNotNil: aName.
	^ (self new) initializeWith: aName.
]

{ #category : #initialization }
Ship >> initializeWith: aName [ 
	name := aName
]

{ #category : #'instance creation' }
Ship >> playIn: aBoard with: aDice [ 
	| diceResult fromCell toCell |
	diceResult := aDice throw.
	fromCell := aBoard whereIs: self.
	toCell := aBoard moveFrom: fromCell times: diceResult.
	fromCell remove: self.
	toCell enters: self.
]
