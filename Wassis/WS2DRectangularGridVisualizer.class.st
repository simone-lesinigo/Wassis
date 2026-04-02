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
			(tile isPathTile ifTrue: [ (self matrix paths at: tile pathID) inspect ]) 
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
							aTile wfcClass name asString ] ] ].

	^ RSPopup new text: [ text ]
]

{ #category : 'shapes' }
WS2DRectangularGridVisualizer >> createBitmapFor: aTile [
	
	^ RSBitmap new
		form: (self tileVisualizer createFormFor: aTile);
		extent: 50 @ 50;
		yourself
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createShapeAt: aPoint [

	| node shape tile |
	node := (self matrix nodes at: aPoint x) at: aPoint y.
	tile := node tileInWhichCollapsed .

	shape := self createBitmapFor: tile.					
	shape @ (self buildPopupFor: tile).
	self addClickTo: shape.	

	self canvas add: shape.
	self shapesNodes at: shape put: node
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createVisualizationFor: aSolver [
	"Create the visualization at the end of the execution"
	
	self matrix: aSolver graph.
	self shapesNodes: Dictionary new.
	self tileVisualizer: 
		(WS2DSquareTileVisualizer withPathIDs: 
			(aSolver topology swSystem classesPathIDs)).

	1 to: aSolver topology nRows do: [ :i |
			1 to: aSolver topology nColumns do: [ :j |
				self createShapeAt: i @ j. ] ].

	RSGridLayout new
		gapSize: 0;
		lineItemsCount: aSolver topology nColumns;
		on: self canvas nodes.

	self canvas openOnce.
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> openCanvas [

	self canvas openOnce
]
