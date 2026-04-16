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
	
	^ (nOfClasses * 1.5) rounded 
]

{ #category : 'visualization' }
WSAdaptive2DGridSolver >> createGraphVisualization [ 
	
	| visualizer |
	visualizer:= WSClassesGraphVisualizer withClasses: (self swSystem classes).
	visualizer createVisualization.
]

{ #category : 'logging' }
WSAdaptive2DGridSolver >> logGridSize: size [

	Transcript 
		show: 'New Grid with size: ';
		show: size;
		show: ' * ';
		showCr: size.
]

{ #category : 'running' }
WSAdaptive2DGridSolver >> run [
	"self createGraphVisualization."
   [ 
		| duration |
		duration := [ 
			self solveWithIncreasingSize.
			Smalltalk garbageCollect.
			"self save"
		] timeToRun.
	
		Transcript 
			show: 'Execution finished in ';
			show: (duration asDuration); cr.
			
	] forkNamed: 'WaveFunctionCollapse'.
]

{ #category : 'resolving' }
WSAdaptive2DGridSolver >> solveWithIncreasingSize [
	| size |
	size:= self computeInitialSize.
   
	[ self solutionFound ] whileFalse: [
   		[ 
			Smalltalk garbageCollect.
			self logGridSize: size.
			self solveWithSize: size.
       ] on: WSMaxTriesReached, WSNoValidPlacementFound do: [ 
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
	
"	currentSolver graph nodes: currentSolver graph nodes flattened.
	currentSolver graph nodes do: [ :each | each isCollapsed ifFalse: [ each collapseTo: (self topology new createEmptyTile) ] ].
	currentSolver createVisualization.
	self halt."
   currentSolver run.

	self solver: currentSolver.
	self solutionFound: true
]
