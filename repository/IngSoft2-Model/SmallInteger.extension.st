Extension { #name : #SmallInteger }

{ #category : #'*IngSoft2-Model' }
SmallInteger >> lightYears [

	^ Lightyears amount: self
]

{ #category : #'*IngSoft2-Model' }
SmallInteger >> parsecs [

	^ Parsecs amount: self
]

{ #category : #'*IngSoft2-Model' }
SmallInteger >> toCellsOf: aBoard [
	^ self
]
