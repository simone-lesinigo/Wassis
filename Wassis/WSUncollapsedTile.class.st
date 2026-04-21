"
Represents a tile that is not collapsed yet. Used only for debug purposes
"
Class {
	#name : 'WSUncollapsedTile',
	#superclass : 'WSTile',
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'visualization' }
WSUncollapsedTile >> accept: aVisitor [ 

	^ aVisitor visitUncollapsedTile: self
]

{ #category : 'control' }
WSUncollapsedTile >> addItemToMenu: aMenu onNode: aNode usingSolver: aSolver [
	"This method is intentionally empty"
	
	^ nil
]

{ #category : 'visualization' }
WSUncollapsedTile >> buildPopup [ 
	
	^ nil
]
