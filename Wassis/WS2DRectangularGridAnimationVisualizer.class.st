"
Allows you to visualize the animation of WFC algorithm
"
Class {
	#name : 'WS2DRectangularGridAnimationVisualizer',
	#superclass : 'WS2DRectangularGridVisualizer',
	#instVars : [
		'presenter',
		'diffPerStep',
		'index',
		'maxIndex',
		'msDelay',
		'isPlaying'
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
WS2DRectangularGridAnimationVisualizer >> createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap [
	"Given the initial shapes on the canvas (step 0) it creates the differences for each step"
	
	self solver historyOfCollapsedNodes doWithIndex: [ :eachNode :i |
		| collapsedNodeShape waveTouchedNodesShapes allShapes |
		collapsedNodeShape := self createShapeFor: eachNode.

		waveTouchedNodesShapes := self
			createWaveShapeFor: (self solver historyOfTouchedNodes at: i)
	         withColorMap: anEntropyColorMap.

		allShapes := { collapsedNodeShape } , waveTouchedNodesShapes.
		
		diffPerStep at: i at: #removedShapes put: OrderedCollection new.
		diffPerStep at: i at: #addedShapes put: OrderedCollection new.
		allShapes do: [ :eachShape |
			initialActiveShapes at: eachShape position ifPresent: [ :oldShape | ((diffPerStep at: i) at: #removedShapes) add: oldShape  ].
			initialActiveShapes at: eachShape position put: eachShape.
			((diffPerStep at: i) at: #addedShapes) add: eachShape 
		].
	].
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createFullWaveVisualization: aSolver withMilliSecDelay: aDelay withColorMap: anEntropyColorMap [
	"Create a timelapse with the progress of the collapse of the solution"

	| initialActiveShapes |
	
	self initializeWith: aSolver.
	self msDelay: aDelay.
	self setMinAndMaxIn: anEntropyColorMap.
	
	initialActiveShapes := (self addInitialWaveShapesWithColorMap: anEntropyColorMap).
	self createDiffPerStepWith: initialActiveShapes andColorMap: anEntropyColorMap.

	presenter setCanvas: self canvas.
	presenter open.
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
		  shape @ (RSPopup new text: ('' join: {'Entropy: ' . eachNode entropy printShowingDecimalPlaces: 3})).
		  shape when: RSMouseLeftClick do: [ eachNode inspect ] for: self.
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
	self isPlaying: false
]

{ #category : 'initialization' }
WS2DRectangularGridAnimationVisualizer >> initializeWith: aSolver [
	
	super initializeWith: aSolver.
	self maxIndex: 	aSolver historyOfCollapsedNodes size.
	presenter := WSAnimationPresenter new visualizer: self.
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
	
	[	isPlaying := true.	
	   [(index < maxIndex) and: isPlaying] whileTrue: [
	   		self stepForward.
	      (Delay forMilliseconds: msDelay) wait. 
	   ]
	] forkNamed: 'WassisPlayAnimation'
	
"	isPlaying := true.
     (index to: maxIndex) do: [ :i |
        self stepForward.
        (Delay forMilliseconds: msDelay) wait. 
     ] displayingProgress: 'Animation progress'"
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> presenter [

	^ presenter
]

{ #category : 'accessing' }
WS2DRectangularGridAnimationVisualizer >> presenter: anObject [

	presenter := anObject
]

{ #category : 'visualization' }
WS2DRectangularGridAnimationVisualizer >> setMinAndMaxIn: anEntropyColorMap [
	"Find the min and the max entropy during the whole execution of the algorithm. Set them as attributes of the color map"
	
	| temp1 temp2 |
	temp1 := self solver copyOfInitalNodes collect: [ :eachNode | eachNode entropy ].
	temp2 := self solver historyOfTouchedNodes flattened collect: [ :eachNode | eachNode entropy ].
	
	anEntropyColorMap 
		minEntropy: ((temp1 min) min: (temp2 min));
		maxEntropy: ((temp1 max) max: (temp2 max))
	
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> stepBack [
	"Return to the previous step of the visualization on the canvas"

	| diff |
	index > 0 ifFalse: [ ^ self ].
	diff := diffPerStep at: index.
	(diff at: #addedShapes) do: [ :eachShape |self canvas removeShape: eachShape ].
	index := index - 1.
	self canvas addAll: ((diff at: #removedShapes) collect: [ :eachShape | eachShape ]).
	self canvas invalidate
]

{ #category : 'animation' }
WS2DRectangularGridAnimationVisualizer >> stepForward [
	"Draw the next step of the visualization on the canvas"

	| diff |
	index < maxIndex ifFalse: [ ^ self ].

	index := index + 1.
	diff := diffPerStep at: index.
	(diff at: #removedShapes) do: [ :eachShape |self canvas removeShape: eachShape ].
	self canvas addAll: ((diff at: #addedShapes) collect: [ :eachShape | eachShape ]).
	self canvas invalidate
]
