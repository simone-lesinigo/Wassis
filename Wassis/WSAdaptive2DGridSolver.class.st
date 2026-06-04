"
Increase the size of the 2D grid
"
Class {
	#name : 'WSAdaptive2DGridSolver',
	#superclass : 'WSAdaptiveSolver',
	#instVars : [
		'metrics'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'instance creation' }
WSAdaptive2DGridSolver class >> withTopology: aTopology andSwSystem: aSwSystem [
	
	^ self new 
		topology: aTopology;
		swSystem: aSwSystem
	
	
]

{ #category : 'calculating' }
WSAdaptive2DGridSolver >> computeInitialSize [
	<toDo> "Improve the formula to compute the initial size"
	| nOfClasses |
	nOfClasses := self swSystem classes size.
	WSLogger log: ('Number of classes: {1}' format: { nOfClasses asString }).
	^ (nOfClasses * 0.8) rounded 
]

{ #category : 'visualization' }
WSAdaptive2DGridSolver >> createGraphVisualization [ 
	
	| visualizer |
	visualizer:= WSClassesGraphVisualizer withClasses: (self swSystem classes).
	visualizer createVisualization.
]

{ #category : 'visualization-history' }
WSAdaptive2DGridSolver >> createHistoryVisualization [

	self solver createHistoryVisualization
]

{ #category : 'visualization-history' }
WSAdaptive2DGridSolver >> createHistoryVisualizationWithMilliSecDelay: aDelay [

	self solver createHistoryVisualizationWithMilliSecDelay: aDelay
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> executeRun [

    | totalTime |
    metrics := WSMetrics new.
    self resetEnvironment.
    WSCurrentMetrics value: metrics during: [
        totalTime := [ self solveWithIncreasingSize. Smalltalk garbageCollect ] timeToRun.
        self updatePerformanceMetricsWithTime: totalTime.
        WSConfig isHeadless ifTrue: [ self save ].
		  WSCurrentMetrics getPerformanceMetrics visualizationTime: [ self createVisualization ] timeToRun.
        WSLogger log: ('Execution finished in {1}' format: { totalTime humanReadablePrintString }).
    ]
]

{ #category : 'logging' }
WSAdaptive2DGridSolver >> logGridSize: size [
	
	WSLogger log: ('New grid with size: {1} * {2}' format: { size . size }).
]

{ #category : 'cleanup' }
WSAdaptive2DGridSolver >> resetEnvironment [
	
	WSConfig reset.
	WSConfig placementStrategy resetCache.
	WSTileVisitor resetPathIDColorDictionary 
	
	
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> run [

    WSConfig isHeadless 
        ifTrue: [ self executeRun ]
        ifFalse: [ [ self executeRun ] forkNamed: 'WaveFunctionCollapse' ]
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> solveWithIncreasingSize [
	"Create new solvers with increasing size"

    | size solverID |
    size := self computeInitialSize.
    solverID := 1.
    [ self solutionFound ] whileFalse: [
        [ self trySolveWithSize: size andID: solverID ]
            on: WSNoValidPlacementFound, WSMaxTriesReached
            do: [ :e | 
                WSLogger log: e logMessage, String cr.
                size := size + 1.
                solverID := solverID + 1 ]
    ]

]

{ #category : 'running' }
WSAdaptive2DGridSolver >> solveWithSize: aSize andID: aID [
	| currentSolver |
	currentSolver := (WSSolver 
    	withTopology: (self topology withGrid: aSize @ aSize) 
      andSwSystem: self swSystem
		andID: aID).
	
	currentSolver addInitialMetrics.

	"WS2DRectangularGridVisualizer new visualizeMDSPositionFor: currentSolver."
	"self visualizeMDSDistancesMatrixFor: currentSolver."
	"currentSolver createTemporaryVisualization. self halt."
	self solver: currentSolver.
   WSCurrentMetrics getPerformanceMetrics solverTotalTime: [currentSolver run] timeToRun.

	self saveFailedExecutionHistory.
	self solutionFound: true
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> trySolveWithSize: aSize andID: aID [

    Smalltalk garbageCollect.
    self saveFailedExecutionHistory.
    self solver: nil.
    self logGridSize: aSize.
    self solveWithSize: aSize andID: aID
]

{ #category : 'metrics' }
WSAdaptive2DGridSolver >> updatePerformanceMetricsWithTime: totalTime [
	"Update the performance metrics when the execution is completed"

	| performanceMetrics |
	performanceMetrics := WSCurrentMetrics getPerformanceMetrics.

	performanceMetrics 
		totalTime: totalTime;
		embeddingTime: WSConfig placementStrategy computationTime.
	
	"Only the first solver calculates the MDS position matrix, for the others is cached"
	self solver id ~= 1 ifTrue: [ 
		performanceMetrics solverTotalTime: (performanceMetrics solverTotalTime + performanceMetrics embeddingTime).
	].
	
	performanceMetrics wastedTime: (totalTime - (performanceMetrics solverTotalTime)).
	
	
	
]

{ #category : 'visualization' }
WSAdaptive2DGridSolver >> visualizeFailedExectuions [
	
	historyOfFailedExecutions keysAndValuesDo: [ :eachDimension :eachCollection | 
		| canvas |
		canvas := RSCanvas new.
		canvas addAll: (eachCollection collect: [ :eachFailedExecution | eachFailedExecution createCanvas asComposite ]).
		
		RSGridLayout new
			gapSize: 500;
			lineItemsCount: 5;
			on: canvas shapes.
		canvas @ RSCanvasController new.
		canvas openWithTitle: ('Dimension {1}' format: { eachDimension }); zoomToFit.
	]
]
