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
	
	self registerMouseHoverForPathsOf: aSolver.

	RSGridLayout new
		gapSize: 0;
		lineItemsCount: aSolver topology nColumns;
		on: self canvas nodes.
	
	self groupFootprintShapes: aSolver.
	
	self canvas openOnce.
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> groupFootprintShapes: aSolver [
    "For each class, group its footprint shapes into a draggable RSComposite"
    
    aSolver topology classNodes keysAndValuesDo: [ :aClass :aFootprint |
        | footprintShapes composite |

        footprintShapes := aFootprint nodes collect: [ :aNode | self nodesShapes at: aNode ].
        composite := RSComposite new.
        footprintShapes do: [ :shape | composite add: shape ].
        composite @ RSDraggable.
        "composite when: RSMouseDragEnd do: [ :evt | 
            self onDragEnd: evt forClass: aClass footprint: aFootprint ]."
        
        self canvas add: composite ]
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> migrateHoverProperties: aSource to: aTarget [

    #(#normalForm #highlightForm) do: [ :key |
        aTarget removePropertyAt: key ifAbsent: [  ].
        aSource propertyAt: key ifPresent: [ :value |
            aTarget propertyAt: key put: value ] ].
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> openCanvas [

	self canvas openOnce
]

{ #category : 'adding' }
WS2DRectangularGridVisualizer >> registerMouseHoverForPathsOf: aSolver [
	"Highlight a path when the mouse is hovering it"

    aSolver getAllPaths do: [ :path |
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
WS2DRectangularGridVisualizer >> updateVisualizationFor: aNodesArray withSolver: aSolver [
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"

	aNodesArray do: [ :eachNode |
		self updateNodeVisualization: eachNode 
	].
	
	self registerMouseHoverForPathsOf: aSolver.

	self canvas signalUpdate 

]
