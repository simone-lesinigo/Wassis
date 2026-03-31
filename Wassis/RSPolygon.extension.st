Extension { #name : 'RSPolygon' }

{ #category : '*Wassis' }
RSPolygon >> absolutePoints [
	"Return the absolute points on the canvas of self"
	^ self points collect: [ :eachPoint | self position + eachPoint ]
	
]
