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

{ #category : 'visualization-history' }
WS2DRectangularGridVisualizer >> createHistoryVisualization: aSolver withMilliSecDelay: aDelay [
	"Create a timelapse with the progress of the collapse of the solution"
	
	self initializeWith: aSolver.
	
	self canvas openWithTitle: 'WassisHistory'.
		[  
		aSolver historyOfCollapsedNodes do: [ :eachNode | 
			self canvas 
				add: (self createShapeFor: eachNode);
				invalidate;
				zoomToFit.
			(Delay forMilliseconds: aDelay) wait.
		].
		self canvas invalidate
	] forkNamed: 'WassisHistoryVisualization'
	

	
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
	shape position: (self positionOnCanvasForNode: aNode).
						
	tile buildPopup ifNotNil: [ :popup | shape @ popup ].
	self addClickTo: shape.
	
	self shapesNodes at: shape put: aNode.
	self nodesShapes at: aNode put: shape.	

	^ shape
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createVisualizationFor: aSolver [
	"Create the visualization at the end of the execution"
	<toDO> "Change again to the optimized version"
	self initializeWith: aSolver.
	
	self canvas addAll: (aSolver getNotEmptyNodes collect: [ :eachNode | self createShapeFor: eachNode ]).
	"aSolver getNotEmptyNodes do: [ :eachNode | self createShapeFor: eachNode  ]."
	
	"self registerMouseHoverForPaths."
	
	"self groupFootprintShapes."
	
	self canvas openWithTitle: 'Wassis'.
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createWaveShapeFor: waveTouchedNodes [
	"Given a node, it creates the correct shape to visualize it"

    ^ (waveTouchedNodes collect: [ :eachNode |
        | form shape |
        form := self tileVisitor class renderSolidFormWithColor: Color red.
        shape := RSBitmap new
            form: form;
            yourself.
        shape position: (self positionOnCanvasForNode: eachNode).
        shape 
    ])
]

{ #category : 'visualization' }
WS2DRectangularGridVisualizer >> createWaveShapeFor: waveTouchedNodes fromColor: aLowEntropyColor toColor: aHighEntropyColor [
	"Given a node, it creates the correct shape to visualize it"
    | entropies minE maxE diff |
    entropies := waveTouchedNodes collect: [ :n | n entropy ].
	 entropies ifEmpty: [ ^ OrderedCollection new ].
    minE := entropies min.
    maxE := entropies max.
	 diff := maxE - minE.

    ^ (waveTouchedNodes collect: [ :eachNode |
        | t blendedColor form shape |
        t := (maxE = minE)
            ifTrue: [ 0.5 ]
            ifFalse: [ (eachNode entropy - minE) / diff ].
        
        blendedColor := aLowEntropyColor mixed: (1.0 - t) with: aHighEntropyColor.
        
        form := self tileVisitor class renderSolidFormWithColor: blendedColor.
        shape := RSBitmap new form: form; yourself.
        shape position: (self positionOnCanvasForNode: eachNode).
        shape 
    ])
]

{ #category : 'visualization-history' }
WS2DRectangularGridVisualizer >> createWaveVisualization: aSolver withMilliSecDelay: aDelay [
	"Create a timelapse with the progress of the collapse of the solution"
	
	self initializeWith: aSolver.
	self canvas openWithTitle: 'WassisWaveHistory'.
		[  
		aSolver historyOfCollapsedNodes doWithIndex: [ :eachNode :i | 
			| waveTouchedNodesShapes |
			waveTouchedNodesShapes := (self 
				createWaveShapeFor: (aSolver historyOfTouchedNodes at: i)  
				fromColor: Color red     
    			toColor: Color blue).
			
			self canvas 
				add: (self createShapeFor: eachNode);
				addAll: waveTouchedNodesShapes;
				invalidate;
				zoomToFit.
			(Delay forMilliseconds: aDelay) wait.

			waveTouchedNodesShapes do: [ :eachShape |  
				self canvas removeShape: eachShape 
			].
		
			self canvas invalidate.
			
		].
		self canvas invalidate
	] forkNamed: 'WassisHistoryVisualization'
	

	
]

{ #category : 'drag and drop' }
WS2DRectangularGridVisualizer >> groupFootprintShapes [
	"Groups in a RSComposite the shapes of the same class"

	self solver getClassFootprint keysAndValuesDo: [ :aClass :aFootprint |
			| footprintShapes composite |
			footprintShapes := aFootprint nodes collect: [ :aNode |
				                   self nodesShapes at: aNode ].

			composite := RSComposite new.
			composite
				addAll: footprintShapes;
				adjustToChildren.
			footprintShapes do: [ :s |
					s
						when: RSMouseDragging
						do: [ :evt | composite announce: evt ]
						for: self.
					s
						when: RSMouseDragEnd
						do: [ :evt | composite announce: evt ]
						for: self ].
			composite @ RSDraggable new noValidateChildrenEvents.

			self
				registerDragEndOn: composite
				forClass: aClass
				footprint: aFootprint.
			self classComposites at: aClass put: composite.
			self canvas add: composite ]
]

{ #category : 'initialization' }
WS2DRectangularGridVisualizer >> initializeWith: aSolver [
	
	self clear.
	self solver: aSolver.
	self tileVisitor: (WS2DSquareVisitor withPathIDs: aSolver allPathIDs).
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> migrateHoverProperties: aSource to: aTarget [

    #(#normalForm #highlightForm) do: [ :key |
        aTarget removePropertyAt: key ifAbsent: [  ].
        aSource propertyAt: key ifPresent: [ :value |
            aTarget propertyAt: key put: value.
				aSource removePropertyAt: key] ].
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

{ #category : 'calculating' }
WS2DRectangularGridVisualizer >> positionOnCanvasForNode: aNode [
	 "Returns the center position that a node should have on the canvas"
	
    | tileSize col row half |
    tileSize := self tileVisitor class tileSize.
    half := tileSize / 2.
    col := aNode column - 1.
    row := aNode row - 1.
    ^ (col * tileSize + half) @ (row * tileSize + half)
]

{ #category : 'drag and drop' }
WS2DRectangularGridVisualizer >> refreshCompositeFor: aClass oldFootprintNodes: oldNodes newFootprint: newFootprint [

    | oldComposite newShapes newComposite |
    oldComposite := self classComposites at: aClass ifAbsent: [ ^ self ].
    
    oldNodes do: [ :n |
        | s |
        s := self nodesShapes at: n.
        s parent ifNotNil: [ :p | p removeShape: s ].
        self canvas add: s.
        s position: (self positionOnCanvasForNode: n) ].
    oldComposite remove.
    
    newShapes := newFootprint nodes collect: [ :n | self nodesShapes at: n ].
    newComposite := RSComposite new.
    newComposite addAll: newShapes; adjustToChildren.
    
    newShapes do: [ :s |
        s when: RSMouseDragging do: [ :evt | newComposite announce: evt ] for: self.
        s when: RSMouseDragEnd do: [ :evt | newComposite announce: evt ] for: self ].
    newComposite @ (RSDraggable new noValidateChildrenEvents).
    
    self registerDragEndOn: newComposite forClass: aClass footprint: newFootprint.
    self classComposites at: aClass put: newComposite.
    self canvas add: newComposite
]

{ #category : 'pathHovering' }
WS2DRectangularGridVisualizer >> refreshMouseHoverForPaths [
    "Remove all existing hover handlers and re-register cleanly"

    self solver getAllPaths do: [ :path |
        | pathShapes |
        pathShapes := path nodes collect: [ :node | self nodesShapes at: node ].
        pathShapes do: [ :shape |
            shape removeInteractionIfPresent: RSMouseEnter.
            shape removeInteractionIfPresent: RSMouseLeave ] ].
    self registerMouseHoverForPaths.
]

{ #category : 'drag and drop' }
WS2DRectangularGridVisualizer >> registerDragEndOn: composite forClass: aClass footprint: aFootprint [
    | originalPosition |
    originalPosition := composite position copy.
    composite when: RSMouseDragEnd do: [ :evt |
        | nearestNode |
        nearestNode := self
            nearestNodeTo: composite position
            footprintSize: aFootprint sideLength
            inGraph: self solver graph.
        (nearestNode = aFootprint originNode)
            ifTrue: [
                composite position: originalPosition.
                self canvas signalUpdate ]
            ifFalse: [
                (self solver isValidToMove: aClass toNode: nearestNode)
                    ifTrue: [
                        | touchedNodes oldFootprintNodes |
                        oldFootprintNodes := aFootprint nodes copy.
                        touchedNodes := self solver moveClass: aClass toNode: nearestNode.
                        self updateVisualizationFor: touchedNodes.
                        self refreshCompositeFor: aClass
                            oldFootprintNodes: oldFootprintNodes
                            newFootprint: aFootprint ]
                    ifFalse: [
                        composite position: originalPosition.
                        self canvas signalUpdate ] ] ] for: self.
]

{ #category : 'pathHovering' }
WS2DRectangularGridVisualizer >> registerMouseHoverForPaths [
	"Highlight a path when the mouse is hovering it"

    self solver getAllPaths do: [ :path |
        | pathShapes |
        pathShapes := path nodes collect: [ :node | self nodesShapes at: node ].
        self addGroupHoverTo: pathShapes ]
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> updateNodeVisualization: aNode [
	"Update the visualization for a single node"

	 | shape newBitmap |
    shape := self nodesShapes at: aNode.
    newBitmap := aNode tileInWhichCollapsed accept: self tileVisitor.
    
    self updateShape: shape fromBitmap: newBitmap.
    self updatePopup: shape forNode: aNode.
    shape invalidate
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
	 aShape parent ifNotNil: [ :p | p signalUpdate ].
    self migrateHoverProperties: aNewBitmap to: aShape.
]

{ #category : 'update' }
WS2DRectangularGridVisualizer >> updateVisualizationFor: aNodesArray [
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"

	aNodesArray do: [ :eachNode | self updateNodeVisualization: eachNode ].

	self refreshMouseHoverForPaths.
	self canvas signalUpdate
]
