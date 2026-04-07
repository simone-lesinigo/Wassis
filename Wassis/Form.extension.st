Extension { #name : 'Form' }

{ #category : '*Wassis' }
Form >> modifyWithColor: aColor [
	"Takes a form and replace the black with aColor and scale it to 50x50"

	| coloredForm |
	coloredForm := self replaceColor: Color black withColor: aColor.
	^ coloredForm scaledToSize: 50 @ 50
]

{ #category : '*Wassis' }
Form >> replaceColor: oldColor withColor: newColor [
	"Change the color of all the pixels of oldColor to newColor"

	| resultForm |
	resultForm := self copy.
	
	0 to: self width - 1 do: [ :x |
		0 to: self height - 1 do: [ :y |
			(self colorAt: x @ y) = oldColor 
				ifTrue: [ resultForm colorAt: x @ y put: newColor ]
				ifFalse: [ resultForm colorAt: x @ y put: (self colorAt: x @ y) ] ] ].
	^ resultForm
]
