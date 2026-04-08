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
		do: [ self createMenuFor: aShape ]
		for: self
]

{ #category : 'control' }
WS2DRectangularGridVisualizer >> createMenuFor: aShape [
	"Create the menu when right clicking on a shape"
	
	| menu node |
	node := (self shapesNodes at: aShape).
	
	menu := MenuMorph new.
	menu add: 'Inspect Node' target: node selector: #inspect.
	
	node tileInWhichCollapsed 
		addItemToMenu: menu 
		onNode: node 
		usingSolver: self solver.

   menu addLine.
	menu add: 'Cancel' target: menu selector: #deleteIfPopUp.
	
	menu popUpInWorld
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createShapeFor: aNode [

	| tile shape |
	tile := aNode tileInWhichCollapsed.

	shape := tile accept: self tileVisitor .					
	tile buildPopup ifNotNil: [ :popup | shape @ popup ].
	self addClickTo: shape.
	
	self shapesNodes at: shape put: aNode.
	self nodesShapes at: aNode put: shape.	

	self canvas add: shape.
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createVisualizationFor: aSolver [
	"Create the visualization at the end of the execution"
	
	self clear.
	self solver: aSolver.
	"self tileVisitor: WS2DSquareVisitor new."
	self tileVisitor: (WS2DSquareVisitor withPathIDs: aSolver getAllPathIDs).
	
	aSolver getFlattenedNodes do: [ :eachNode | self createShapeFor: eachNode ].

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

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> updateNodeVisualization: aNode [
	"Update the visualization for a single node"

	| shape tile newBitmap |
	shape := (self nodesShapes at: aNode).
	tile := aNode tileInWhichCollapsed.
	
	newBitmap := (tile accept: self tileVisitor).
	
	shape form: newBitmap form.
	newBitmap 
	    propertyAt: #normalForm 
	    ifPresent: [ :value | shape propertyAt: #normalForm put: value ].

	newBitmap 
	    propertyAt: #highlightForm 
	    ifPresent: [ :value | shape propertyAt: #highlightForm put: value ].
	
	shape removeInteractionIfPresent: RSPopup.
	tile buildPopup ifNotNil: [ :popup | shape @ popup ].
	shape invalidate
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> updateVisualizationFor: aNodesArray [ 
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"
	
	aNodesArray do: [ :eachNode |
		self updateNodeVisualization: eachNode 
	]

]
