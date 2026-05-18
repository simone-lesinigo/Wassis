"
Allows you to visualize the animation of WFC algorithm
"
Class {
	#name : 'WS2DRectangularGridAnimationVisualizer',
	#superclass : 'WS2DRectangularGridVisualizer',
	#instVars : [
		'diffPerStep',
		'index',
		'maxIndex',
		'msDelay',
		'isPlaying',
		'announcer'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> addInitialWaveShapesWithColorMap: anEntropyColorMap [
	"Create the initial entropy shapes and add them to the canvas"
	
	| activeShapes initialShapes |
	
	activeShapes := Dictionary new.
		
	initialShapes := self
	 	createWaveShapeFor: self solver copyOfInitalNodes
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
WS2DRectangularGridAnimationVisualizer >> announcer [

	^ announcer
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> announcer: anObject [

	announcer := anObject
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap [
	"Given the initial shapes on the canvas (step 0) it creates the differences for each step"
	
	self solver executionHistory historyOfCollapsedNodes doWithIndex: [ :eachNode :i |
		| collapsedNodeShape waveTouchedNodesShapes allShapes |
		
		collapsedNodeShape := self createShapeFor: eachNode.
		
		waveTouchedNodesShapes := self
			createWaveShapeFor: (self solver executionHistory historyOfTouchedNodes at: i)
	       withColorMap: anEntropyColorMap.
		allShapes := { collapsedNodeShape } , waveTouchedNodesShapes.
		
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

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createFullWaveVisualization: aSolver withMilliSecDelay: aDelay withColorMap: anEntropyColorMap [
	"Create a timelapse with the progress of the collapse of the solution"

	| initialActiveShapes |
	
	self initializeWith: aSolver.
	self msDelay: aDelay.
	self setMinAndMaxIn: anEntropyColorMap.
	
	initialActiveShapes := (self addInitialWaveShapesWithColorMap: anEntropyColorMap).
	self canvas addBorderWithColor: Color black andWidth: 20.
	self addGridLabelsToCanvas: self canvas.
	self createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap.

	presenter setCanvas: self canvas.
	presenter open.
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createPossibleTilesCanvasFor: aNode [
	"Create a separate camvas with the remaining possible tiles for a node"

	| possibleTilesCanvas |
	possibleTilesCanvas := RSCanvas new.
	aNode possibleTiles do: [ :eachTile | 
		| shape |
		shape := eachTile accept: self tileVisitor.
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
			index printString.
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

{ #category : 'as yet unclassified' }
WS2DRectangularGridAnimationVisualizer >> goToIndex: aTargetIndex [
    "Go to the specified index of the visualization"

    (aTargetIndex < 0 or: [ aTargetIndex > maxIndex ]) ifTrue: [ self error: 'Index out of bounds' ].

    index < aTargetIndex
        ifTrue:  [ index to: aTargetIndex - 1 do: [ :_ | self stepForward ] ]
        ifFalse: [ index to: aTargetIndex + 1 by: -1 do: [ :_ | self stepBack ] ]
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> goToStart [
	"Reset the canvas to the initial state"
	
	index to: 0 by: -1 do: [ :i |
		self stepBack 
	]
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> index [

	^ index
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WS2DRectangularGridAnimationVisualizer >> initialize [ 

	super initialize.
	self diffPerStep: Dictionary new.
	self index: 0.
	self isPlaying: false.
	self announcer: Announcer new
]

{ #category : 'initialization' }
WS2DRectangularGridAnimationVisualizer >> initializeWith: aSolver [

	super initializeWith: aSolver.
	self maxIndex: 	aSolver executionHistory historyOfCollapsedNodes size.
	presenter := WSAnimationPresenter withVisualizer: self
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> isPlaying [

	^ isPlaying
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> isPlaying: anObject [

	isPlaying := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> maxIndex [

	^ maxIndex
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> maxIndex: anObject [

	maxIndex := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> msDelay [

	^ msDelay
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> msDelay: anObject [

	msDelay := anObject
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> pause [
	"Pause the animation"
	
	self isPlaying: false
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> play [
	"Play the animation forward"
	
	[  isPlaying := true.	
	   [(index < maxIndex) and: isPlaying] whileTrue: [
	   		self stepForward.
	      (Delay forMilliseconds: msDelay) wait. 
	   ].
		index = maxIndex ifTrue: [ 
			isPlaying := false.
			announcer announce: WSAnimationFinished .
		]
	] forkNamed: 'WassisPlayAnimation'
	
"	isPlaying := true.
     (index to: maxIndex) do: [ :i |
        self stepForward.
        (Delay forMilliseconds: msDelay) wait. 
     ] displayingProgress: 'Animation progress'"
]

{ #category : 'visualization' }
WS2DRectangularGridAnimationVisualizer >> setMinAndMaxIn: anEntropyColorMap [
	"Find the min and the max entropy during the whole execution of the algorithm. Set them as attributes of the color map"
	
	| temp1 temp2 |
	temp1 := self solver copyOfInitalNodes collect: [ :eachNode | eachNode entropy ].
	temp2 := self solver executionHistory historyOfTouchedNodes flattened collect: [ :eachNode | eachNode entropy ].
	
	anEntropyColorMap 
		minEntropy: ((temp1 min) min: (temp2 min));
		maxEntropy: ((temp1 max) max: (temp2 max))
	
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> stepBack [
	"Return to the previous step of the visualization on the canvas"

	| diff |
	index - 1 = 0 ifTrue: [ self announcer announce: WSAtStartOfAnimation. ].
	index > 0 ifFalse: [ ^ self ].
	diff := diffPerStep at: index.
	(diff at: #addedShapes) do: [ :eachShape | self canvas removeShape: eachShape ].
	index := index - 1.
	self announcer announce: WSAnimationIndexChanged.
	self canvas addAll: (diff at: #removedShapes).
	self canvas invalidate
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> stepForward [
	"Draw the next step of the visualization on the canvas"

	| diff |
	index + 1 = maxIndex ifTrue: [ announcer announce: WSAnimationFinished  ].
	index < maxIndex ifFalse: [ ^ self ].

	index := index + 1.
	self announcer announce: WSAnimationIndexChanged .
	diff := diffPerStep at: index.
	(diff at: #removedShapes) do: [ :eachShape | self canvas removeShape: eachShape ].
	self canvas addAll: (diff at: #addedShapes).
	self canvas invalidate
]
