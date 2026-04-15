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

{ #category : 'adding' }
WS2DRectangularGridVisualizer >> addClickTo: aShape [
	"Add the inspect when left clicking, the contextual menu when rightclicking"
	
	aShape
		when: RSMouseLeftClick 
		do: [ (self shapesNodes at: aShape) inspect ]
		for: self.
		
	aShape 
		when: RSMouseRightClick 
		do: [ self createMenuFor: aShape ]
		for: self
]

{ #category : 'adding' }
WS2DRectangularGridVisualizer >> addGroupHoverTo: aCollectionOfShapes [
	"To all the shapes in the collection add the highlights when one of the shape is hovered"

    aCollectionOfShapes do: [ :shape |
        shape
            when: RSMouseEnter
            do: [ 
                aCollectionOfShapes do: [ :s |
                    s form: (s propertyAt: #highlightForm).
                    s invalidate ] ]
            for: self.

        shape
            when: RSMouseLeave
            do: [ 
                aCollectionOfShapes do: [ :s |
                    s form: (s propertyAt: #normalForm).
                    s invalidate ] ]
            for: self ]
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
	"Given a node, it creates the correct shape to visualize it"

	| tile shape |
	tile := aNode tileInWhichCollapsed.

	shape := tile accept: self tileVisitor.			
						
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

	WS2DSquareVisitor clearCache.
	self tileVisitor: (WS2DSquareVisitor withPathIDs: aSolver getAllPathIDs).
	
	aSolver getFlattenedNodes do: [ :eachNode | self createShapeFor: eachNode ].
	
	self registerMouseHoverForPaths.

	RSGridLayout new
		gapSize: 0;
		lineItemsCount: aSolver topology nColumns;
		on: self canvas nodes.
	
	self groupFootprintShapes.
	
	self canvas openOnceWithTitle: 'Wassis'.
]

{ #category : 'drag and drop' }
WS2DRectangularGridVisualizer >> groupFootprintShapes [
	"Group the classnodes into a composite so that you can interact with the class"

	self solver getClassNodes keysAndValuesDo: [ :aClass :aFootprint |
			| footprintShapes composite originalPosition |
			footprintShapes := aFootprint nodes collect: [ :aNode | self nodesShapes at: aNode ].

			composite := RSComposite new.
			composite addAll: footprintShapes; adjustToChildren.
			originalPosition := composite position copy.

			footprintShapes do: [ :s | 
				s when: RSMouseDragging do: [ :evt | composite announce: evt ] for: self.
				s when: RSMouseDragEnd do: [ :evt | composite announce: evt ] for: self ].

			composite @ (RSDraggable new noValidateChildrenEvents).

			composite when: RSMouseDragEnd do: [ :evt |
            | nearestNode |
            nearestNode := self nearestNodeTo: (composite position) footprintSize: (aFootprint sideLength) inGraph: self solver graph.
            (nearestNode = aFootprint originNode)
                ifTrue: [ 
                    composite position: originalPosition.
                    self canvas signalUpdate ]
                ifFalse: [
						  (self solver isValidToMove: aClass toNode: nearestNode)
								ifTrue: [ self updateVisualizationFor: (self solver moveClass: aClass toNode: nearestNode).
									"self solver createVisualization" ]
								ifFalse: [ 
									composite position: originalPosition.
									self canvas signalUpdate  ].
	
                    
      				 ] ] for: self.

			self canvas add: composite ]
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> migrateHoverProperties: aSource to: aTarget [

    #(#normalForm #highlightForm) do: [ :key |
        aTarget removePropertyAt: key ifAbsent: [  ].
        aSource propertyAt: key ifPresent: [ :value |
            aTarget propertyAt: key put: value ] ].
]

{ #category : 'retrieving' }
WS2DRectangularGridVisualizer >> nearestNodeTo: aPoint footprintSize: n inGraph: aGraph [
    "Returns the nearest node to aPoint. aPoint should be the center"

    | cellSize firstNodeShape firstNodeCenter col row topology offset |
	 topology := self solver topology.

    firstNodeShape := self nodesShapes at: (aGraph atRow: 1 atColumn: 1).
    cellSize := firstNodeShape extent x.
    firstNodeCenter := firstNodeShape position.
    
    offset := (n - 1) / 2.0 * cellSize.
    
    col := (((aPoint x - offset) - firstNodeCenter x) / cellSize) rounded + 1.
    row := (((aPoint y - offset) - firstNodeCenter y) / cellSize) rounded + 1.
    
    col := (col max: 1) min: topology nColumns.
    row := (row max: 1) min: topology nRows.
    
    ^ aGraph atRow: row atColumn: col
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> openCanvas [

	self canvas openOnce
]

{ #category : 'adding' }
WS2DRectangularGridVisualizer >> registerMouseHoverForPaths [
	"Highlight a path when the mouse is hovering it"

    self solver getAllPaths do: [ :path |
        | pathShapes |
        pathShapes := path nodes collect: [ :node | self nodesShapes at: node ].
        self addGroupHoverTo: pathShapes ]
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> updateNodeVisualization: aNode [
	"Update the visualization for a single node"

	 | shape newBitmap |
    shape := self nodesShapes at: aNode.
    newBitmap := aNode tileInWhichCollapsed accept: self tileVisitor.
    
    self updateShape: shape fromBitmap: newBitmap.
    self updatePopup: shape forNode: aNode.
    shape invalidate.
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> updatePopup: aShape forNode: aNode [

    aShape removeInteractionIfPresent: RSPopup.
    aNode tileInWhichCollapsed buildPopup
        ifNotNil: [ :popup | aShape @ popup ].
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> updateShape: aShape fromBitmap: aNewBitmap [

    aShape form: aNewBitmap form.
    self migrateHoverProperties: aNewBitmap to: aShape.
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> updateVisualizationFor: aNodesArray [
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"

	aNodesArray do: [ :eachNode |
		self updateNodeVisualization: eachNode 
	].
	
	self registerMouseHoverForPaths.

	self canvas signalUpdate 

]
