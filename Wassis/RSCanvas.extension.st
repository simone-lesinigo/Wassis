Extension { #name : 'RSCanvas' }

{ #category : '*Wassis' }
RSCanvas >> clearShapes [

	self shapes do: #remove.
	self signalUpdate
]
