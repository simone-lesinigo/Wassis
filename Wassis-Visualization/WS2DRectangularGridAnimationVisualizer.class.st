"
Allows you to visualize the animation of WFC algorithm
"
Class {
	#name : 'WS2DRectangularGridAnimationVisualizer',
	#superclass : 'WS2DRectangularGridVisualizer',
	#instVars : [
		'model',
		'animationData',
		'diffPerStep'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'instance creation' }
WS2DRectangularGridAnimationVisualizer class >> withModel: aModel andColorMap: aColorMap [

	| instance |
	instance := self basicNew model: aModel; initialize.
	instance createAnimationWithColorMap: aColorMap.
	^ instance
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> addInitialWaveShapesWithColorMap: anEntropyColorMap [
	"Create the initial entropy shapes and add them to the canvas"
	
	| activeShapes initialShapes |
	
	activeShapes := Dictionary new.
		
	initialShapes := self
	 	createWaveShapeFor: self solver executionHistory copyOfInitalNodes
		withColorMap: anEntropyColorMap.

		initialShapes do: [ :eachShape |
			self canvas add: eachShape.
			activeShapes at: eachShape position put: eachShape ].

	^ activeShapes 
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> addInteractionToShape: aShape withNode: aNode [
	"Add the interactions to a shape that it is not collapsed yet (showing entropy)"
	
	aShape @ (RSPopup new text: ('' join: {'Entropy: ' . aNode entropy printShowingDecimalPlaces: 3})).
   aShape 
		when: RSMouseLeftClick do: [ aNode inspect ] for: self;
		when: RSMouseRightClick do: [ self createEntropyMenuFor: aNode ] for: self
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> animationData [

	^ animationData
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> animationData: anObject [

	animationData := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> canvas [

	^ canvas
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> canvas: anObject [

	canvas := anObject
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createAnimationWithColorMap: anEntropyColorMap [
	"Create a timelapse with the progress of the collapse of the solution"

	| initialActiveShapes |
	"self animationData: (self model createAnimationData)."
	
	self initializeWith: (self model solver).
	self setMinAndMaxIn: anEntropyColorMap.
	
	initialActiveShapes := (self addInitialWaveShapesWithColorMap: anEntropyColorMap).
	self canvas addBorderWithColor: Color black andWidth: 20.
		self canvas 
		addGridLabelsWithTileSize: self tileVisitor class tileSize 
		withDimension: solver nRows @ solver nColumns.
	self createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap.

]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap [
	"Given the initial shapes on the canvas (step 0) it creates the differences for each step"
	
	self solver executionHistory historyOfCollapsedNodes doWithIndex: [ :eachCollectionOfNode :i |
		| allCollapsedNodeShape waveTouchedNodesShapes allShapes |
		allCollapsedNodeShape := eachCollectionOfNode collect: [ :eachNode | self createShapeFor: eachNode ].
		
		waveTouchedNodesShapes := self
			createWaveShapeFor: (self solver executionHistory historyOfTouchedNodes at: i)
	       withColorMap: anEntropyColorMap.
		allShapes :=  allCollapsedNodeShape, waveTouchedNodesShapes.
		
		diffPerStep at: i at: #removedShapes put: OrderedCollection new.
		diffPerStep at: i at: #addedShapes put: OrderedCollection new.
		
		((diffPerStep at: i) at: #addedShapes) addAll: 
			(allShapes collect: [ :eachShape |
				initialActiveShapes at: eachShape position ifPresent: [ :oldShape | ((diffPerStep at: i) at: #removedShapes) add: oldShape ].
				initialActiveShapes at: eachShape position put: eachShape.
				eachShape ]) 
	 ]
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createEntropyMenuFor: aNode [
	"Create the menu associated with a node that it is not collapsed yet (showing its entropy)"
		
	| menu |
	
	menu := MenuMorph new.
	menu add: 'Inspect Node' target: aNode selector: #inspect.
	menu add: 'Possible Tiles' target: [ self createPossibleTilesCanvasFor: aNode ] selector: #value.

   menu addLine.
	menu add: 'Cancel' target: menu selector: #deleteIfPopUp.
	
	menu popUpInWorld
]

{ #category : 'deprecated' }
WS2DRectangularGridAnimationVisualizer >> createFullWaveVisualization: aSolver withMilliSecDelay: aDelay withColorMap: anEntropyColorMap [
	"Create a timelapse with the progress of the collapse of the solution"

	| initialActiveShapes |
	
"	self initializeWith: aSolver."
	self msDelay: aDelay.
	self setMinAndMaxIn: anEntropyColorMap.
	
	initialActiveShapes := (self addInitialWaveShapesWithColorMap: anEntropyColorMap).
	self canvas addBorderWithColor: Color black andWidth: 20.
	self addGridLabelsToCanvas: self canvas.
	self createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap.

]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createPossibleTilesCanvasFor: aNode [
	"Create a separate camvas with the remaining possible tiles for a node"

	| possibleTilesCanvas |
	possibleTilesCanvas := RSCanvas new.
	aNode possibleTiles do: [ :eachTile | 
		| shape |
		shape := eachTile accept: self solver topology visualizer tileVisitor.
		possibleTilesCanvas add: shape.
		shape borderColor: Color black.
		shape when: RSMouseLeftClick do: [ eachTile inspect ] for: self
	].
	 
	RSGridLayout new
		gapSize: 50;
		lineItemsCount: 10;
		on: possibleTilesCanvas nodes.
		
	possibleTilesCanvas @ RSCanvasController.
	possibleTilesCanvas 
		openWithTitle: 
			'Possible tiles of node ', 
			aNode position printString,
			' at step ',
			self model index printString.
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createWaveShapeFor: waveTouchedNodes withColorMap: anEntropyColorMap [
	"Given a collection of nodes, it creates the correct shapes to visualize them"
	
    | diff maxE minE |
	 waveTouchedNodes ifEmpty: [ ^ OrderedCollection new ].
	
	 maxE := anEntropyColorMap maxEntropy.
	 minE := anEntropyColorMap minEntropy.
	 diff := maxE - minE.

    ^ (waveTouchedNodes collect: [ :eachNode |
        | t blendedColor form shape |
        t := (maxE = minE)
            ifTrue: [ 0.5 ]
            ifFalse: [ (eachNode entropy - minE) / diff ].
        
        blendedColor := anEntropyColorMap lowEntropyColor mixed: (1.0 - t) with: anEntropyColorMap highEntropyColor.
        
        form := self tileVisitor class renderSolidFormWithColor: blendedColor.
        shape := RSBitmap new form: form; yourself.
        shape position: (self positionOnCanvasForNode: eachNode).
		  self addInteractionToShape: shape withNode: eachNode.
        shape 
    ])
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> diffPerStep [

	^ diffPerStep
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> diffPerStep: anObject [

	diffPerStep := anObject
]

{ #category : 'initialization' }
WS2DRectangularGridAnimationVisualizer >> initialize [ 

	super initialize.
	diffPerStep := Dictionary new.
	
	model announcer 
		when: WSAnimationStepForward 
		do: [ self onStepForward ]
		for: self.
		
	model announcer 
		when: WSAnimationStepBack 
		do: [ self onStepBack ]
		for: self.
	
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> model [

	^ model
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> model: anObject [

	model := anObject
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> onStepBack [
	"Return to the previous step of the visualization on the canvas"

	| diff |
	diff := diffPerStep at: model index + 1.
	(diff at: #addedShapes) do: [ :eachShape | self canvas removeShape: eachShape ].
	self canvas addAll: (diff at: #removedShapes).
	self canvas invalidate
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> onStepForward [
	"Draw the next step of the visualization on the canvas"

	| diff |
	diff := diffPerStep at: model index.
	(diff at: #removedShapes) do: [ :eachShape | self canvas removeShape: eachShape ].
	self canvas addAll: (diff at: #addedShapes).
	self canvas invalidate
]

{ #category : 'calculating' }
WS2DRectangularGridAnimationVisualizer >> setMinAndMaxIn: anEntropyColorMap [
	"Find the min and the max entropy during the whole execution of the algorithm. Set them as attributes of the color map"
	
	| temp1 temp2 eh |
	eh := self solver executionHistory.
	temp1 := eh copyOfInitalNodes collect: [ :eachNode | eachNode entropy ].
	temp2 := eh historyOfTouchedNodes flattened collect: [ :eachNode | eachNode entropy ].
	
	anEntropyColorMap 
		minEntropy: ((temp1 min) min: (temp2 min));
		maxEntropy: ((temp1 max) max: (temp2 max))
	
]
