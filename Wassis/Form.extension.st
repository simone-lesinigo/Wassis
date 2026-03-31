Extension { #name : 'Form' }

{ #category : '*Wassis' }
Form >> modifyWithColor: aColor [
	"Takes a form and replace the black with aColor and scale it to 50x50"

	| newForm |
	newForm := self replaceColor: Color black withColor: aColor.
	newForm := newForm scaledToSize: 50 @ 50.
	^ newForm
]

{ #category : '*Wassis' }
Form >> replaceColor: oldColor withColor: newColor [
	"Change the color of all the pixels of oldColor to newColor"
	
	| newForm |
	newForm := self copy.

	0 to: self width - 1 do: [ :x |
			0 to: self height - 1 do: [ :y |
					(newForm colorAt: x @ y) = oldColor ifTrue: [
						newForm colorAt: x @ y put: newColor ] ] ].
	^ newForm
]
