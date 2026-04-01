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

{ #category : 'serializing' }
WSAdaptive2DGridSolver class >> savePath [

    ^ '/Users/Simo/Desktop/Wassis/solution-', DateAndTime nowAsString, '.fuel'
]

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
	
	^ (nOfClasses * 2)
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
		self solveWithIncreasingSize.
		self save.
	
	] forkNamed: 'WaveFunctionCollapse'.
]

{ #category : 'actions' }
WSAdaptive2DGridSolver >> save [

	self serializeToFileNamed: self class savePath
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
       ] on: WSMaxTriesReached do: [ 
        	size := size + 1 
       ].
	]
]

{ #category : 'resolving' }
WSAdaptive2DGridSolver >> solveWithSize: aSize [
	| solver |
	
	solver := WSSolver 
    	withTopology: (self topology withGrid: aSize @ aSize) 
      andSwSystem: self swSystem.

   solver run.

	self solutionFound: true
]
