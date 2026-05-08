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
	Transcript show: 'Number of classes: ', nOfClasses asString; cr.
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
WSAdaptive2DGridSolver >> createTemporaryVisualizationFor: aSolver [
	
	aSolver createTemporaryVisualization.
	self halt.
]

{ #category : 'logging' }
WSAdaptive2DGridSolver >> logGridSize: size [

	Transcript 
		show: 'New grid with size: ';
		show: size; show: ' * '; show: size;
		cr.
]

{ #category : 'cleanup' }
WSAdaptive2DGridSolver >> resetEnvironment [
	
	WSConfig reset.
	WSMDSLayoutStrategy resetCache.
	WSTileVisitor resetPathIDColorDictionary 
	
	
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> run [
	
	metrics := WSMetrics new.
	self resetEnvironment.
	"self createGraphVisualization."
   [ 
		WSCurrentMetrics value: metrics during: [
			| totalTime |
			totalTime := [ 
				self solveWithIncreasingSize.
				Smalltalk garbageCollect.
			] timeToRun.
		  self updatePerformanceMetricsWithTime: totalTime.

		  Transcript show: 'Execution finished in '; show: (totalTime humanReadablePrintString); cr.
		].	
	] forkNamed: 'WaveFunctionCollapse'.

	
   
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
			Transcript show: 'No valid placement found for this grid, trying with new one'; cr; cr. 
        	size := size + 1.
			solverID := solverID + 1.
       ]] on: WSMaxTriesReached do: [
			Transcript show: 'Max n of tries reached for this grid'; cr; cr. 
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
	
	"self createTemporaryVisualizationFor: currentSolver."
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
