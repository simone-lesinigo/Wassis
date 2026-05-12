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
	^ (nOfClasses * 1.5) rounded 
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

{ #category : 'visualization' }
WSAdaptive2DGridSolver >> createMDSClassesPositionViusalizationFor: aSolver [
	
	| newVisualizer |
	newVisualizer := aSolver topology visualizer class new.
	newVisualizer visualizeMDSPositionFor: aSolver.
	self halt.
]

{ #category : 'visualization' }
WSAdaptive2DGridSolver >> createTemporaryVisualizationFor: aSolver [
	
	aSolver createTemporaryVisualization.
	self halt.
]

{ #category : 'logging' }
WSAdaptive2DGridSolver >> logGridSize: size [
	
	WSLogger log: ('New grid with size: {1} * {2}' format: { size . size }).
]

{ #category : 'cleanup' }
WSAdaptive2DGridSolver >> resetEnvironment [
	
	WSConfig reset.
	WSMDSLayoutStrategy resetCache.
	WSTileVisitor resetPathIDColorDictionary 
	
	
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> run [
	
	| block |
	block := [  
		metrics := WSMetrics new.
		self resetEnvironment.
		"self createGraphVisualization."
		WSCurrentMetrics value: metrics during: [
			| totalTime |
			totalTime := [ 
				self solveWithIncreasingSize.
				Smalltalk garbageCollect.
			] timeToRun.
		  self updatePerformanceMetricsWithTime: totalTime.
		  WSConfig isHeadless ifTrue: [ self save ].
		  WSLogger log: ('Execution finished in {1}' format: { totalTime humanReadablePrintString }).  
		  self inspect
		]
	].
	
	WSConfig isHeadless 
        ifTrue: [ block value ]
        ifFalse: [ block forkNamed: 'WaveFunctionCollapse' ]
]

{ #category : 'resolving' }
WSAdaptive2DGridSolver >> solveWithIncreasingSize [
	"Create new solvers with increasing size"

	| size solverID |
	size:= self computeInitialSize.
	solverID := 1.

	[ self solutionFound ] whileFalse: [
   		[[ 
			Smalltalk garbageCollect.
			self logGridSize: size.
			self solveWithSize: size andID: solverID.
       ] on: WSNoValidPlacementFound do: [
			WSLogger log: 'No valid placement found for this grid, trying with new one', String cr. 
        	size := size + 1.
			solverID := solverID + 1.
       ]] on: WSMaxTriesReached do: [
			WSLogger log: 'Max n of tries reached for this grid', String cr. 
			size := size + 1.
			solverID := solverID + 1.
		].
	]

]

{ #category : 'resolving' }
WSAdaptive2DGridSolver >> solveWithSize: aSize andID: aID [
	| currentSolver |
	currentSolver := (WSSolver 
    	withTopology: (self topology withGrid: aSize @ aSize) 
      andSwSystem: self swSystem
		andID: aID).
	
	currentSolver addInitialMetrics.
	
"	self createMDSClassesPositionViusalizationFor: currentSolver.
	self createTemporaryVisualizationFor: currentSolver."
   WSCurrentMetrics getPerformanceMetrics solverTotalTime: [currentSolver run] timeToRun.

	self solver: currentSolver.
	self solutionFound: true
]

{ #category : 'metrics' }
WSAdaptive2DGridSolver >> updatePerformanceMetricsWithTime: totalTime [
	"Update the performance metrics when the execution is completed"

	| performanceMetrics |
	performanceMetrics := WSCurrentMetrics getPerformanceMetrics.

	performanceMetrics 
		totalTime: totalTime;
		mdsTime: WSMDSLayoutStrategy computationTime.
	
	"Only the first solver calculates the MDS position matrix, for the others is cached"
	self solver id ~= 1 ifTrue: [ 
		performanceMetrics solverTotalTime: (performanceMetrics solverTotalTime + performanceMetrics mdsTime).
	].
	
	performanceMetrics wastedTime: (totalTime - (performanceMetrics solverTotalTime)).
	
	
	
]
