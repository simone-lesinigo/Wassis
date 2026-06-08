"
The head of the monster, it's the class that executes the algorithm
"
Class {
	#name : 'WSSolver',
	#superclass : 'WSObject',
	#instVars : [
		'id',
		'graph',
		'backtracking',
		'topology',
		'executionHistory'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'deprecated' }
WSSolver class >> withTopology: aTopology andSwSystem: aSwSystem [

	| graph |
	aTopology initializeWith: aSwSystem.
	graph := aTopology createGraph.
	
	^ self new
		graph: graph;
		topology: aTopology;
		backtracking: (WSBacktracking newWithGraph: graph)

		
		

]

{ #category : 'instance creation' }
WSSolver class >> withTopology: aTopology andSwSystem: aSwSystem andID: aID [

	| graph inst |
	aTopology initializeWith: aSwSystem.
	graph := aTopology createGraph.
	
	inst :=  self new
		id: aID;
		graph: graph;
		topology: aTopology;
		backtracking: (WSBacktracking newWithGraph: graph).
	
	inst executionHistory copyOfInitalNodes: aTopology initialNodes.
	
	^ inst

		
		

]

{ #category : 'metrics' }
WSSolver >> addInitialGraphMetrics [
	"Add the total number of nodes and the dimension"
	
	| graphMetrics |
	graphMetrics := WSCurrentMetrics getGraphMetrics.
	
	graphMetrics totalNumberOfNodes: self graph nodes size.
	graphMetrics dimension: self graph structure dimension
]

{ #category : 'metrics' }
WSSolver >> addInitialMetrics [
	
	self addInitialPathMetrics.
	self addInitialGraphMetrics.
	self addSoftwareMetrics.
	self addTilesetMetrics.
	self addPlacementMetrics.
	
]

{ #category : 'metrics' }
WSSolver >> addInitialPathMetrics [
	"Add only the number of direct, merging and total paths"
	
	| pathMetrics dict nOfDirect |
	pathMetrics := WSCurrentMetrics getPathMetrics.
	
	dict := ((self topology swSystem classesPathIDs) values groupedBy: [ :each | each ] ) collect: [ :group | group size ].
	nOfDirect := (dict select: [ :each | each = 1 ]) size.
	
	pathMetrics numberOfDirectPaths: nOfDirect.
	pathMetrics numberOfMergingPaths: (dict size - nOfDirect).
	pathMetrics totalNumberOfPaths: (pathMetrics numberOfDirectPaths + pathMetrics numberOfMergingPaths).

]

{ #category : 'error handling' }
WSSolver >> addOneToTotalNumberOfTries [
	
	| pm |
	pm := WSCurrentMetrics getPerformanceMetrics.
	pm totalNumberOfTries: (pm totalNumberOfTries + 1).
]

{ #category : 'metrics' }
WSSolver >> addPlacementMetrics [
	
	| placementMetrics |
	placementMetrics := WSCurrentMetrics getPlacementMetrics.
	placementMetrics 
		classDistances: (self topology calculateDistancesBetweenClasses);
		avgConnectedClassesDistance: (self calculateAvgConnectedClassesDistance)

]

{ #category : 'metrics' }
WSSolver >> addSoftwareMetrics [
	"Add number of classes, number of connection per class, avg number of connections per class"
	
	| swSystem swMetrics counter |
	counter := 0.
	swSystem := self topology swSystem.
	swMetrics := WSCurrentMetrics getSoftwareMetrics.
	
	swMetrics numberOfClasses: swSystem classes size.
	
	swSystem allConnectionsPerClass keysAndValuesDo: [ :eachClass :allConnections | 
		| size |
		size := allConnections size.
		swMetrics numberOfConnectionsPerClass at: eachClass put: size.
		counter := counter + size.
	].

	swMetrics avgNumOfConnectionsPerClass: (counter / (swMetrics numberOfClasses))
	
	
	
	
]

{ #category : 'metrics' }
WSSolver >> addTilesetMetrics [
	"Add the number of tiles in the tileset"
	
	| numberOfTiles |
	numberOfTiles := self topology tileset tiles size.
	WSCurrentMetrics getTilesetMetrics numberOfTiles: numberOfTiles 
]

{ #category : 'accessing' }
WSSolver >> allPathIDs [ 
	
	^ self topology allPathIDs 
]

{ #category : 'as yet unclassified' }
WSSolver >> assignArrowDirectionsToAllPaths [
	"Assign the direction in which the arrow should be for all paths"

	self graph paths do: [ :eachPath |
		eachPath assignArrowDirections 
	]
]

{ #category : 'accessing' }
WSSolver >> backtracking [

	^ backtracking
]

{ #category : 'accessing' }
WSSolver >> backtracking: anObject [

	backtracking := anObject
]

{ #category : 'metrics' }
WSSolver >> calculateAverageNeighborDistanceFor: aClass [
	"Calculate the avg distance of each class considering all the class it is connected to"

    | connections distances classDistances |
	 classDistances := WSCurrentMetrics getPlacementMetrics classDistances.

    connections := classDistances keys select: [ :assoc | 
        assoc key = aClass or: [ assoc value = aClass ] ].
    
    connections ifEmpty: [ ^ 0 ].
    
    distances := connections collect: [ :assoc | classDistances at: assoc ].

    ^ distances average
]

{ #category : 'metrics' }
WSSolver >> calculateAvgConnectedClassesDistance [

	| dict |
	dict := Dictionary new.
	
	self topology swSystem classes do: [ :eachClass | 
		dict at: eachClass put: (self calculateAverageNeighborDistanceFor: eachClass)
	].
	
	^ dict
]

{ #category : 'post processing' }
WSSolver >> classifyPathTiles [
    "Iterates over all graph nodes, groups tiles by their pathID, and registers them into the tileset"

    | pathGroups |
    pathGroups := Dictionary new.

    self graph nodes do: [ :eachNode |
        | tile |
        tile := eachNode tileInWhichCollapsed.
        tile isPathTile ifTrue: [
            tile pathIDs do: [ :aPathID |
                (pathGroups at: aPathID ifAbsentPut: [ Set new ]) add: tile ] ] ].

    pathGroups keysAndValuesDo: [ :aSymbol :pathTiles |
        self topology tileset pathTiles at: aSymbol put: pathTiles ].
]

{ #category : 'path optimization' }
WSSolver >> clearAllPathsOf: aClass [
	"Destroy all the paths associated to a class"
	| pathIDs touchedNodes |
	touchedNodes := OrderedCollection new.
	pathIDs := self topology swSystem pathIDsOf: aClass.
	
	pathIDs do: [ :eachPathID  | 
		touchedNodes addAll: (self graph clearPathWithID: eachPathID) ].
	
	^ touchedNodes
]

{ #category : 'running' }
WSSolver >> collapseNextNode [

    | node |
    node := self graph selectNextNodeToCollapse.
    node := node collapseTo: node selectInWhichTileToCollapse.
    self graph addOneToCollapsedNodes.
    node collapseStep: self executionHistory historyOfCollapsedNodes size + 1.
    ^ node
]

{ #category : 'copying' }
WSSolver >> copyOfNodesWithoutEdges: touchedNodes [
	
	^ (touchedNodes collect: [ :eachNode | 
			eachNode copyWithoutEdges 
	  ]) asOrderedCollection 
]

{ #category : 'visualization-history' }
WSSolver >> createHistoryVisualization [
	"Create a timelapse with the progress of the collapse of the solution"

	self createHistoryVisualizationWithMilliSecDelay: 50
]

{ #category : 'visualization-history' }
WSSolver >> createHistoryVisualizationWithMilliSecDelay: aDelay [
	"Create a timelapse with the progress of the collapse of the solution"

	| class visualizer |
	class := self topology visualizer class.
	visualizer := class new.
	visualizer createHistoryVisualization: self withMilliSecDelay: aDelay
]

{ #category : 'visualization' }
WSSolver >> createTemporaryVisualization [
	"Create a temporary visualization that does not affect at all self. All the node that were not collapsed are not displayed"
	
	| copyOfSelf uncollapsedTile |
	uncollapsedTile := self topology createUncollapsedTile.
	copyOfSelf := self veryDeepCopy.
	copyOfSelf graph nodes do: [ :eachNode | 
		eachNode isNotCollapsed ifTrue: [
       	(eachNode hasZeroPossibleTiles)
                ifTrue: [ eachNode collapseTo: self topology createErrorTile ]
                ifFalse: [  eachNode collapseTo: uncollapsedTile ] ] ].
	copyOfSelf createVisualization
	
]

{ #category : 'deprecated' }
WSSolver >> createVisualization [ 
	
	self topology createVisualizationForSolver: self
]

{ #category : 'visualization' }
WSSolver >> createVisualizationWith: adaptiveSolver [
	
	self topology createVisualizationFor: adaptiveSolver 
]

{ #category : '2DGrid' }
WSSolver >> dimension [
	
	^ self graph structure dimension
]

{ #category : 'running' }
WSSolver >> ensureHeapIsNotEmpty [

    self graph entropyHeap ifEmpty: [ self graph restoreEntropyHeap ]
]

{ #category : 'accessing' }
WSSolver >> executionHistory [

	^ executionHistory
]

{ #category : 'accessing' }
WSSolver >> executionHistory: anObject [

	executionHistory := anObject
]

{ #category : 'serialization' }
WSSolver >> fuelAfterMaterialization [ 
	
	self graph topology: self topology
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

{ #category : 'accessing' }
WSSolver >> id [

	^ id
]

{ #category : 'accessing' }
WSSolver >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
WSSolver >> initialize [ 
	super initialize.
	self executionHistory: WSExecutionHistory new.
]

{ #category : 'testing' }
WSSolver >> isValidToMove: aClass toNode: aNode [
	
	^ self topology isValidToMove: aClass toNode: aNode onGraph: self graph.
]

{ #category : 'logging' }
WSSolver >> logTotalTries [

	| totalNumberOfTries |
	totalNumberOfTries := WSCurrentMetrics getPerformanceMetrics totalNumberOfTries.
	
	(totalNumberOfTries \\ 10 = 0) ifTrue: [ 
		WSLogger log: ('Tries: {1}' format: { totalNumberOfTries }). ].
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

{ #category : '2DGrid' }
WSSolver >> nColumns [

	^ self graph structure nColumns
]

{ #category : '2DGrid' }
WSSolver >> nRows [ 

	^ self graph structure nRows
]

{ #category : 'error handling' }
WSSolver >> onContradiction [
	"Method executed when a contradiction has been found"

	| bt | 
	"self createTemporaryVisualization. self halt."
	self updateExecutionHistory.
	
	bt := self backtracking.
	self addOneToTotalNumberOfTries.
	self logTotalTries.
	
	"bt restartFromClassesGraphForSolver: self."
	bt addOneToContradictionPerGraph.

	(bt nOfContradicitonsPerGraph) >= (bt maxNumberOfTriesPerGraph) ifFalse: [ ^ self ].

	bt restartFromEmptyGraphForSolver: self.
	
	bt nOfRegeneratedGraph >= bt maxNumberOfRegeneratedGraph
		ifTrue: [ WSMaxTriesReached signal. ]
]

{ #category : 'running' }
WSSolver >> propagateFrom: collapsedNode andResolved: resolvedNodes [

    | touchedNodes |

    touchedNodes := self graph propagate: collapsedNode.
    resolvedNodes do: [ :each |  touchedNodes addAll: (self graph propagate: each) ].

    ^  touchedNodes
]

{ #category : 'running' }
WSSolver >> recordHeapSnapshot [
	"Save a snapshot of the heap"

    self executionHistory historyOfMinEntropyHeap 
        add: (self copyOfNodesWithoutEdges: self graph entropyHeap)
]

{ #category : 'running' }
WSSolver >> recordStepHistory: collapsedNode resolved: resolvedNodes touched: touchedNodes [
	"Update the history"

    | eh |

    eh := self executionHistory.
    eh historyOfCollapsedNodes add: (self copyOfNodesWithoutEdges: ({ collapsedNode }, resolvedNodes)).
    eh historyOfTouchedNodes add: (self copyOfNodesWithoutEdges: touchedNodes).
]

{ #category : 'path reification' }
WSSolver >> reifyWFCPaths [
	"Create the instances of WFCPath"
	self graph createPaths.
	"self graph destroyRandomLoops.
	self graph deleteUselessCrossingFromAllPaths.	
	self graph destroyPathLoops.
	self graph deleteUselessCrossingFromAllPaths."
	self graph mergePathsWithSameID.
	"self graph correctPaths."
	self graph setPathLengths.
	"self graph calculatePathMetrics."
	 self assignArrowDirectionsToAllPaths.

	
	
	
	

]

{ #category : 'running' }
WSSolver >> resolvePathIfNeeded: aNode [
	"If a node collapsed into a resolved path tile (no placeholder in edges) it propagates the information to the neighbours that are collapsed into placeholder path tiles, if present"

    (aNode isPathNode and: [ aNode tileInWhichCollapsed isResolvedTile ])
        ifFalse: [ ^ {} ].
    ^ self graph propagatePathIDResolutionFrom: aNode
]

{ #category : 'running' }
WSSolver >> run [
	"Run the WFC algorithm on the graph" 
	
	| performanceMetrics |
	performanceMetrics := WSCurrentMetrics getPerformanceMetrics.
	
	performanceMetrics wfcTime: [ self solveGraph ] timeToRun .
	WSLogger log: 'Solution found'.

	self classifyPathTiles.
	self topology rebuildClassNodes: self graph.

	performanceMetrics pathReificationTime: [ self reifyWFCPaths ] timeToRun.
	self updateGraphMetrics.
	
	
	
	
]

{ #category : 'running' }
WSSolver >> solveGraph [
	"Core method that executes WFC"
	
	WSLogger log: 'Execution started'.

	[ self graph allNodesCollapsed ] whileFalse: [ 
		[  
			self step			
		] on: WSContradiction 
		  do: [ 
			self onContradiction ]
	]
]

{ #category : 'running' }
WSSolver >> step [
	"Take a step of the algorithm (select a node to collapse, collapse it and propagate)"
	
	| collapsedNode touchedNodes resolvedNodes |
	
	self ensureHeapIsNotEmpty.
	self recordHeapSnapshot.
	
	collapsedNode := self collapseNextNode.
	resolvedNodes := self resolvePathIfNeeded: collapsedNode.
	touchedNodes := self propagateFrom: collapsedNode andResolved: resolvedNodes.
		
	self recordStepHistory: collapsedNode resolved: resolvedNodes touched: touchedNodes.
]

{ #category : 'accessing' }
WSSolver >> topology [

	^ topology
]

{ #category : 'accessing' }
WSSolver >> topology: anObject [

	topology := anObject
]

{ #category : 'error handling' }
WSSolver >> updateExecutionHistory [

	| eh |
	eh := self executionHistory.
	eh reset.
	
	WSConfig saveFailedExecution ifTrue: [  
		eh	historyOfFailedExecutions add: 
			(self topology asFailedExecution 
			timestamp: DateAndTime now
			nOfTry: WSCurrentMetrics getPerformanceMetrics totalNumberOfTries
			solver: self)
	]
]

{ #category : 'metrics' }
WSSolver >> updateGraphMetrics [
	"Set the number of empty, path and class nodes"
	
	| graphMetrics classNodes pathNodes |
	graphMetrics := WSCurrentMetrics getGraphMetrics.
	
	classNodes := 0.
	self topology classFootprint do: [ :eachFootprint | classNodes := classNodes + eachFootprint nodes size ].
	
	pathNodes := 0.
	self graph paths do: [ :eachPath | pathNodes := pathNodes + eachPath nodes size ].
	
	graphMetrics 
		numberOfClassNodes: classNodes; 
		numberOfPathNodes: pathNodes; 
		numberOfEmptyNodes: (graphMetrics totalNumberOfNodes - classNodes - pathNodes )
	
	
]

{ #category : 'visualization' }
WSSolver >> updateVisualizationFor: aNodesArray [
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"
	
	self topology visualizer updateVisualizationFor: aNodesArray
]
