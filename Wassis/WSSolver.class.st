"
The head of the monster, it's the class that executes the algorithm
"
Class {
	#name : 'WSSolver',
	#superclass : 'WSObject',
	#instVars : [
		'graph',
		'backtracking',
		'topology'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'instance creation' }
WSSolver class >> withTopology: aTopology andSwSystem: aSwSystem [

	| graph |
	
	aTopology initializeWith: aSwSystem.
	graph := aTopology createGraph.

	^ self new
		graph: graph;
		topology: aTopology;
		backtracking: (WSBacktracking newWithGraph: graph)

		
		

]

{ #category : 'accessing' }
WSSolver >> backtracking [

	^ backtracking
]

{ #category : 'accessing' }
WSSolver >> backtracking: anObject [

	backtracking := anObject
]

{ #category : 'visualization' }
WSSolver >> createVisualization [ 
	
	self topology visualizer createVisualizationFor: self
]

{ #category : 'serialization' }
WSSolver >> fuelAfterMaterialization [ 
	
	self graph topology: self topology
]

{ #category : 'accessing' }
WSSolver >> getAllPathIDs [

	^ self topology swSystem classesPathIDs
]

{ #category : 'accessing' }
WSSolver >> getFlattenedNodes [

	^ self graph getFlattenedNodes 
]

{ #category : 'accessing' }
WSSolver >> graph [

	^ graph
]

{ #category : 'accessing' }
WSSolver >> graph: anObject [

	graph := anObject
]

{ #category : 'error handling' }
WSSolver >> onContradiction [

	| bt |
	bt := self backtracking.

	bt restartFromClassesGraphForSolver: self.

	(bt nOfContradicitonsPerGraph) > (bt maxNOfTriesPerGraph) ifFalse: [ ^ self ].

	bt restartFromEmptyGraphForSolver: self.
	Transcript show: 'Tries: ';
	showCr: (bt nOfRegeneratedGraph) * (bt maxNOfTriesPerGraph).
	
	bt nOfRegeneratedGraph >= bt maxNOfRegeneratedGraph 
		ifTrue: [ WSMaxTriesReached signal.  ]
]

{ #category : 'reification' }
WSSolver >> reifyWFCPaths [
	"Create the instances of WFCPath"
	
	self graph createPaths.
	self graph setPathLengths.
	"self graph assignPathsToNodes."
	self graph destroyLoops.
	
	
	
	

]

{ #category : 'running' }
WSSolver >> run [
	"Run the WFC algorithm on the graph" 
	| duration |
	duration := [ self solveGraph ] timeToRun.
	Transcript 
		show: 'Execution finished in ';
		show: (duration asDuration); cr.
	
	self reifyWFCPaths.
	self graph optimizeAllPathsAllowingExitModifications: true.
	self createVisualization.

	"WS2DRectangularGridVisualizer  new createVisualizationFor: self."
]

{ #category : 'running' }
WSSolver >> solveGraph [
	"Core method that executes WFC"
	
	[ self graph allNodesCollapsed ] whileFalse: [ 
		[  
			self step.
			self graph addOneToCollapsedNodes
		] on: WSContradiction 
			 do: [ self onContradiction ]
	]
]

{ #category : 'running' }
WSSolver >> step [
	"Take a step of the algorithm (select a node to collapse, collapse it and propagate)"
	
	| collapsedNode |
	
	self graph minEntropyHeap ifEmpty: [ self graph restoreMinEntropyHeap ].
	
	collapsedNode := (self graph selectNextNodeToCollapse).
	collapsedNode := collapsedNode collapseTo: (collapsedNode selectInWhichTileToCollapse).
	self graph propagate: collapsedNode.

	^ collapsedNode
]

{ #category : 'accessing' }
WSSolver >> topology [

	^ topology
]

{ #category : 'accessing' }
WSSolver >> topology: anObject [

	topology := anObject
]
