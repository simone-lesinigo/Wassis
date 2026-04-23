"
Increase the size of the 2D grid
"
Class {
	#name : 'WSAdaptive2DGridSolver',
	#superclass : 'WSAdaptiveSolver',
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

{ #category : 'visualization' }
WSAdaptive2DGridSolver >> createTemporaryVisualizationFor: aSolver [
	
	aSolver createTemporaryVisualization
]

{ #category : 'logging' }
WSAdaptive2DGridSolver >> logGridSize: size [

	Transcript 
		show: 'New grid with size: ';
		show: size; show: ' * '; show: size;
		cr.
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> run [
	WSConfig resetInstance.
	"self createGraphVisualization."
   [ 
		| duration |
		duration := [ 
			self solveWithIncreasingSize.
			Smalltalk garbageCollect.
		] timeToRun.
	
		Transcript show: 'Execution finished in '; show: (duration asDuration); cr.
			
	] forkNamed: 'WaveFunctionCollapse'.
]

{ #category : 'resolving' }
WSAdaptive2DGridSolver >> solveWithIncreasingSize [
	| size |
	size:= self computeInitialSize.
   
	[ self solutionFound ] whileFalse: [
   		[[ 
			Smalltalk garbageCollect.
			self logGridSize: size.
			self solveWithSize: size.
       ] on: WSNoValidPlacementFound do: [
			Transcript show: 'No valid placement found for this grid, trying with new one'; cr; cr. 
        	size := size + 1 
       ]] on: WSMaxTriesReached do: [
			Transcript show: 'Max n of tries reached for this grid'; cr; cr. 
			size := size + 1
		].
	]

]

{ #category : 'resolving' }
WSAdaptive2DGridSolver >> solveWithSize: aSize [
	| currentSolver |
	currentSolver := (WSSolver 
    	withTopology: (self topology withGrid: aSize @ aSize) 
      andSwSystem: self swSystem).
	
	currentSolver addInitialMetrics.
	
	"self createTemporaryVisualizationFor: currentSolver."
   currentSolver run.

	self solver: currentSolver.
	self solutionFound: true
]
