Extension { #name : 'RSCanvas' }

{ #category : '*Wassis' }
RSCanvas >> asComposite [
	
	^ RSComposite new addAll: self shapes copy; adjustToChildren
]
