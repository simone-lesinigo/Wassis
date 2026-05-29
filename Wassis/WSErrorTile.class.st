"
Tile that represents a node with zero possibilities
"
Class {
	#name : 'WSErrorTile',
	#superclass : 'WSTile',
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'visualization' }
WSErrorTile >> accept: aVisitor [ 

	^ aVisitor visitErrorTile: self
]

{ #category : 'control' }
WSErrorTile >> addItemToMenu: aMenu onNode: aNode usingSolver: aSolver [
	"This method is intentionally empty"
	
	^ nil
]

{ #category : 'visualization' }
WSErrorTile >> buildPopup [ 
	
	^ nil
]
