Class {
	#name : 'WS2DRectangularGridAnimationVisualizer',
	#superclass : 'WS2DRectangularGridVisualizer',
	#instVars : [
		'diffPerStep',
		'index',
		'maxIndex',
		'msDelay'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createFullWaveVisualization: aSolver withMilliSecDelay: aDelay fromColor: aLowEntropyColor toColor: aHighEntropyColor [
	"Create a timelapse with the progress of the collapse of the solution"

	| minAndMax activeShapes initialShapes presenter |
	[ 
		self initializeWith: aSolver.
		self maxIndex: 	aSolver historyOfCollapsedNodes size.
		self msDelay: aDelay.
		presenter := WSAnimationPresenter new visualizer: self.
		activeShapes := Dictionary new.
		minAndMax := self findMinAndMaxEntropy.
		
		initialShapes := self
	   		 createWaveShapeFor: aSolver copyOfInitalNodes
	       fromColor: aLowEntropyColor
	       toColor: aHighEntropyColor
	       withMin: minAndMax first
	       andMax: minAndMax last.

		initialShapes do: [ :eachShape |
			self canvas add: eachShape.
			activeShapes at: eachShape position put: eachShape ].
		
		aSolver historyOfCollapsedNodes doWithIndex: [ :eachNode :i |
			| collapsedNodeShape waveTouchedNodesShapes allShapes |
			collapsedNodeShape := self createShapeFor: eachNode.

			waveTouchedNodesShapes := self
				createWaveShapeFor: (aSolver historyOfTouchedNodes at: i)
	         fromColor: aLowEntropyColor
	         toColor: aHighEntropyColor
	         withMin: minAndMax first
	         andMax: minAndMax last.

			allShapes := { collapsedNodeShape } , waveTouchedNodesShapes.
			
			diffPerStep at: i at: #removedShapes put: OrderedCollection new.
			diffPerStep at: i at: #addedShapes put: OrderedCollection new.
			allShapes do: [ :eachShape |
				activeShapes at: eachShape position ifPresent: [ :oldShape | ((diffPerStep at: i) at: #removedShapes) add: oldShape  ].
				activeShapes at: eachShape position put: eachShape.
				((diffPerStep at: i) at: #addedShapes) add: eachShape 
			].
		].

		presenter setCanvas: self canvas.
		presenter open.
	] forkNamed: 'WassisHistoryVisualization'
]

{ #category : 'visualization-historyWave' }
WS2DRectangularGridAnimationVisualizer >> createWaveShapeFor: waveTouchedNodes fromColor: aLowEntropyColor toColor: aHighEntropyColor withMin: minE andMax: maxE [
	"Given a node, it creates the correct shape to visualize it"
	
    | entropies diff |
    entropies := waveTouchedNodes collect: [ :n | n entropy ].
	 entropies ifEmpty: [ ^ OrderedCollection new ].
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
	self index: 0
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

{ #category : 'as yet unclassified' }
WS2DRectangularGridAnimationVisualizer >> play [
    [ index < maxIndex ] do: [ 
        self stepForward.
        (Delay forMilliseconds: msDelay) wait. 
    ] displayingProgress: 'Animation progress'
]

{ #category : 'as yet unclassified' }
WS2DRectangularGridAnimationVisualizer >> stepBack [
	"Return to the previous step of the visualization on the canvas"

	| diff |
	index > 0 ifFalse: [ ^ self ].

	index := index - 1.
	diff := diffPerStep at: index + 1.
	(diff at: #addedShapes) do: [ :eachShape |self canvas removeShape: eachShape ].
	self canvas addAll: ((diff at: #removedShapes) collect: [ :eachShape | eachShape ]).
	self canvas invalidate
]

{ #category : 'as yet unclassified' }
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
