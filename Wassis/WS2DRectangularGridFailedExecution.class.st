"
2D Rectangular Grid failed execution
"
Class {
	#name : 'WS2DRectangularGridFailedExecution',
	#superclass : 'WSFailedExecution',
	#category : 'Wassis-History',
	#package : 'Wassis',
	#tag : 'History'
}

{ #category : 'instance creation' }
WS2DRectangularGridFailedExecution class >> timestamp: aTimestamp nOfTry: numberOfTry solver: aSolver [

	| instance |
	instance := super timestamp: aTimestamp nOfTry: numberOfTry solver: aSolver.
	instance tileVisitor: (WS2DSquareVisitor withPathIDs: aSolver allPathIDs).
	
	^ instance
]

{ #category : 'visualization' }
WS2DRectangularGridFailedExecution >> collapseUncollapsedNodes [
	"To visualize the failed solution we have select a tile for each uncollapsed node"

    | uncollapsedTile |
    uncollapsedTile := self topology createUncollapsedTile.
    self copyOfNodes: (self copyOfNodes collect: [ :eachNode |
        eachNode isNotCollapsed ifTrue: [
            eachNode tileInWhichCollapsed: (eachNode hasZeroPossibleTiles
                ifTrue: [ self topology createErrorTile ]
                ifFalse: [ uncollapsedTile ]) ].
        eachNode ])
]

{ #category : 'visualization' }
WS2DRectangularGridFailedExecution >> createCanvas [

	 self collapseUncollapsedNodes.
    ^ WS2DRectangularGridFailedExecutionVisualizer new visualizeFailedExecution: self.

	
]

{ #category : 'visualization' }
WS2DRectangularGridFailedExecution >> createVisualization [

    self createCanvas openWithTitle: ('Execution Number {1}' format: { numberOfTry })
	
]
