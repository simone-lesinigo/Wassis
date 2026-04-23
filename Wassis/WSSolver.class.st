"
The head of the monster, it's the class that executes the algorithm
"
Class {
	#name : 'WSSolver',
	#superclass : 'WSObject',
	#instVars : [
		'graph',
		'backtracking',
		'topology',
		'metrics'
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

{ #category : 'pathOptimization' }
WSSolver >> clearAllPathsOf: aClass [
	"Destroy all the paths associated to a class"
	| pathIDs touchedNodes |
	touchedNodes := OrderedCollection new.
	pathIDs := self topology swSystem pathIDsOf: aClass.
	
	pathIDs do: [ :eachPathID  | 
		touchedNodes addAll: (self graph clearPathWithID: eachPathID) ].
	
	^ touchedNodes
]

{ #category : 'visualization' }
WSSolver >> createTemporaryVisualization [
	"Create a temporary visualization that does not affect at all self. All the node that were not collapsed are displayd as lightGray"
	
	| copyOfSelf |
	Transcript show: 'Started creating temporary visualization'; cr; cr.
	copyOfSelf := self veryDeepCopy.
	copyOfSelf createVisualization.
	
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

	^ self topology getAllPathIDs
]

{ #category : 'accessing' }
WSSolver >> getAllPaths [
	
	^ self graph paths
]

{ #category : 'accessing' }
WSSolver >> getClassFootprint [

	^ self topology classFootprint 
]

{ #category : 'accessing' }
WSSolver >> getClassNodes [
	"Returns an ordered collection of the class nodes"
	
	^ self getClassFootprint flatCollect: [ :eachFootprint | eachFootprint nodes ]

]

{ #category : 'accessing' }
WSSolver >> getFlattenedNodes [
	"Get all the nodes"

	^ self graph getFlattenedNodes 
]

{ #category : 'accessing' }
WSSolver >> getNotEmptyNodes [
	"Get all the nodes that didnt collapse into an empty tile"

    ^ self getPathNodes , self getClassNodes
]

{ #category : 'accessing' }
WSSolver >> getPathNodes [
	
	^ self graph getPathNodes
]

{ #category : 'accessing' }
WSSolver >> graph [

	^ graph
]

{ #category : 'accessing' }
WSSolver >> graph: anObject [

	graph := anObject
]

{ #category : 'testing' }
WSSolver >> isValidToMove: aClass toNode: aNode [
	
	^ self topology isValidToMove: aClass toNode: aNode onGraph: self graph.
]

{ #category : 'accessing' }
WSSolver >> metrics [

	^ metrics
]

{ #category : 'accessing' }
WSSolver >> metrics: anObject [

	metrics := anObject
]

{ #category : 'drag and drop' }
WSSolver >> moveClass: aClass toNode: aNode [
	"Move aClass to its new position"
	
	| touchedNodes |
	touchedNodes := Set new.
	touchedNodes 
		addAll: (self clearAllPathsOf: aClass);
		addAll: (self topology 
			moveClass: aClass 
			toNode: aNode 
			inGraph: self graph).

	^ touchedNodes
]

{ #category : 'error handling' }
WSSolver >> onContradiction [

	| bt |
	bt := self backtracking.

	bt restartFromClassesGraphForSolver: self.

	(bt nOfContradicitonsPerGraph) > (bt maxNumberOfTriesPerGraph) ifFalse: [ ^ self ].

	bt restartFromEmptyGraphForSolver: self.
	Transcript show: 'Tries: ';
	showCr: (bt nOfRegeneratedGraph) * (bt maxNumberOfTriesPerGraph).
	
	bt nOfRegeneratedGraph >= bt maxNumberOfRegeneratedGraph
		ifTrue: [ WSMaxTriesReached signal.  ]
]

{ #category : 'pathReification' }
WSSolver >> reifyWFCPaths [
	"Create the instances of WFCPath"
	
	self graph createPaths.
	self graph setPathLengths.
	self graph destroyRandomLoops.
	self graph destroyPathLoops.
	self graph mergePathsWithSameID.
	self graph correctPaths.
	
	
	
	

]

{ #category : 'running' }
WSSolver >> run [
	"Run the WFC algorithm on the graph" 
	
	self solveGraph.
	self reifyWFCPaths.
	self topology rebuildClassNodes: self graph.
	self createVisualization
]

{ #category : 'running' }
WSSolver >> solveGraph [
	"Core method that executes WFC"
	
	Transcript show: 'Execution started'; cr.
	[ self graph allNodesCollapsed ] whileFalse: [ 
		[  
			self step.
			self graph addOneToCollapsedNodes
		] on: WSContradiction 
		  do: [ 
			"self createTemporaryVisualization."
			self onContradiction ]
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

{ #category : 'visualization' }
WSSolver >> updateVisualizationFor: aNodesArray [
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"
	
	self topology visualizer updateVisualizationFor: aNodesArray
]
