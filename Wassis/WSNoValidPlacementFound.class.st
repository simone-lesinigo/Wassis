"
Error raised when during the placement of the classes in the graph no valid node is found
"
Class {
	#name : 'WSNoValidPlacementFound',
	#superclass : 'WSError',
	#category : 'Wassis-Error',
	#package : 'Wassis',
	#tag : 'Error'
}

{ #category : 'logging' }
WSNoValidPlacementFound >> logMessage [

    ^ 'No valid placement found for this grid, trying with new one'
]
