Extension { #name : 'RSCanvas' }

{ #category : '*Wassis' }
RSCanvas >> asComposite [
	
	^ RSComposite new addAll: self shapes copy; adjustToChildren
]

{ #category : '*Wassis' }
RSCanvas >> exportToPDFZoomingToShapes [

	^ self pdfExporter zoomToShapes; export
]
