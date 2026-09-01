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

	aMenu
		add: 'Possible Tiles'
		target: [
				| possibleTilesCanvas |
				possibleTilesCanvas := RSCanvas new.
				aNode possibleTiles do: [ :eachTile |
						| shape |
						shape := eachTile accept:
							         aSolver topology visualizer tileVisitor.
						possibleTilesCanvas add: shape.
						shape borderColor: Color black.
						shape when: RSMouseLeftClick do: [ eachTile inspect ] for: self ].

				RSGridLayout new
					gapSize: 50;
					lineItemsCount: 10;
					on: possibleTilesCanvas nodes.
				possibleTilesCanvas @ RSCanvasController.
				possibleTilesCanvas open
				 ]
		selector: #value
]

{ #category : 'visualization' }
WSUncollapsedTile >> buildPopup [ 
	
	^ nil
]
