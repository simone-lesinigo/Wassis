"
Create the visualization for the rectangular grid
"
Class {
	#name : 'WS2DRectangularGridVisualizer',
	#superclass : 'WS2DGridVisualizer',
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'shapes' }
WS2DRectangularGridVisualizer >> addClickTo: aShape [

	aShape
		when: RSMouseLeftClick 
		do: [ (self shapesNodes at: aShape) inspect ]
		for: self.
		
	aShape 
		when: RSMouseRightClick 
		do: [ 
			| tile |
			tile := (self shapesNodes at: aShape) tileInWhichCollapsed.
			(tile isPathTile ifTrue: [ (self graph paths at: tile pathID) inspect ]) 
		]
		for: self
]

{ #category : 'visual properties' }
WS2DRectangularGridVisualizer >> buildPopupFor: aTile [
	"Returns a popup based on the type of cell"

	| text |
	text := 
		aTile isEmptyTile 
			ifTrue: [ 'Empty Tile' ]
		   ifFalse: [
				aTile isPathTile 
					ifTrue: [ 'Path Tile: ', aTile pathID ]
					ifFalse: [
						aTile isClassTile ifTrue: [
							aTile wsClass name asString ] ] ].

	^ RSPopup new text: [ text ]
]

{ #category : 'shapes' }
WS2DRectangularGridVisualizer >> createBitmapFor: aTile [
	
	^ RSBitmap new
		form: (aTile accept: self tileVisitor);
		extent: 50 @ 50;
		yourself
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createShapeFor: aNode [

	| tile shape |
	tile := aNode tileInWhichCollapsed.

	shape := self createBitmapFor: tile.					
	shape @ (self buildPopupFor: tile).
	self addClickTo: shape.	

	self canvas add: shape.
	self shapesNodes at: shape put: aNode
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createVisualizationFor: aSolver [
	"Create the visualization at the end of the execution"
	
	self graph: aSolver graph.
	self tileVisitor: (WS2DSquareVisitor withPathIDs: aSolver getAllPathIDs).
	aSolver getFlattenedNodes do: [ :eachNode | self createShapeFor: eachNode ].

	RSGridLayout new
		gapSize: 0;
		lineItemsCount: aSolver topology nColumns;
		on: self canvas nodes.
	
	self canvas openWithTitle: 'Wassis'.
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> openCanvas [

	self canvas openOnce
]
