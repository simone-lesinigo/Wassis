Extension { #name : 'NeoJSONObject' }

{ #category : '*Wassis' }
NeoJSONObject >> atPath: aPath default: defaultValue [
	"Search a value in the JSON, if it is not found returns defaultValue"
	
	^ (self atPath: aPath) ifNil: [ defaultValue ]
]
