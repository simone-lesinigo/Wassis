Extension { #name : 'Collection' }

{ #category : '*Wassis' }
Collection >> notIncludes: anObject [
	
	^ (self includes: anObject) not
]
