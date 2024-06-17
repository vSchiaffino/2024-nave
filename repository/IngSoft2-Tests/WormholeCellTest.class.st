Class {
	#name : #WormholeCellTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
WormholeCellTest >> testIfTryToCreateASingleWormholeShouldThrowError [
	self should: [ WormholeCell new ] raise: Error withMessage: 'Use WormholeCell newPairIn: start: end: instead.'.
]
