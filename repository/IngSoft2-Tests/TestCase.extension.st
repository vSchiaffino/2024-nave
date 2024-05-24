Extension { #name : #TestCase }

{ #category : #'*IngSoft2-Tests' }
TestCase >> should: anErrorBlock raise: exceptionClass withMessage: anErrorMessage [

	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: anErrorMessage ]
]
