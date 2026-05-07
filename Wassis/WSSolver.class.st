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
		'copyOfInitalNodes',
		'historyOfCollapsedNodes',
		'historyOfTouchedNodes'
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

{ #category : 'instance creation' }
WSSolver class >> withTopology: aTopology andSwSystem: aSwSystem andID: aID [

	| graph |
	aTopology initializeWith: aSwSystem.
	graph := aTopology createGraph.
	
	^ self new
		id: aID;
		graph: graph;
		copyOfInitalNodes: aTopology initialNodes;
		topology: aTopology;
		backtracking: (WSBacktracking newWithGraph: graph)

		
		

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
	
	Transcript show: 'Tries: '; show: (pm totalNumberOfTries); cr.
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

{ #category : 'accessing' }
WSSolver >> copyOfInitalNodes [

	^ copyOfInitalNodes
]

{ #category : 'accessing' }
WSSolver >> copyOfInitalNodes: anObject [

	copyOfInitalNodes := anObject
]

{ #category : 'copying' }
WSSolver >> copyOfNodesWithoutEdges: touchedNodes [
	
	^ (touchedNodes collect: [ :eachNode | 
			eachNode copyWithoutEdges 
	  ]) asOrderedCollection 
]

{ #category : 'visualization-historyWave' }
WSSolver >> createFullWaveVisualizationWithMilliSecDelay: aDelay fromColor: aLowEntropyColor toColor: aHighEntropyColor [
	"Create a timelapse with the progress of the collapse of the solution and the visualization of the wave"

	| visualizer |
	visualizer := self topology visualizer asAnimationVisualizer.
	visualizer 
		createFullWaveVisualization: self 
		withMilliSecDelay: aDelay 
		withColorMap: (WSEntropyColorMap 
			fromColor: aLowEntropyColor  
			toColor: aHighEntropyColor)
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
	copyOfSelf graph nodes do: [ :eachNode | eachNode isCollapsed ifFalse: [ eachNode collapseTo: uncollapsedTile] ].
	copyOfSelf createVisualization
	
]

{ #category : 'visualization' }
WSSolver >> createVisualization [ 
	
	self topology visualizer createVisualizationFor: self
]

{ #category : 'visualization-historyWave' }
WSSolver >> createWaveVisualizationWithMilliSecDelay: aDelay fromColor: aLowEntropyColor toColor: aHighEntropyColor [
	"Create a timelapse with the progress of the collapse of the solution and the visualization of the wave"

	| class visualizer |
	class := self topology visualizer class.
	visualizer := class new.
	visualizer 
		createWaveVisualization: self 
		withMilliSecDelay: aDelay 
		fromColor: aLowEntropyColor 
		toColor: aHighEntropyColor
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
WSSolver >> historyOfCollapsedNodes [

	^ historyOfCollapsedNodes
]

{ #category : 'accessing' }
WSSolver >> historyOfCollapsedNodes: anObject [

	historyOfCollapsedNodes := anObject
]

{ #category : 'accessing' }
WSSolver >> historyOfTouchedNodes [

	^ historyOfTouchedNodes
]

{ #category : 'accessing' }
WSSolver >> historyOfTouchedNodes: anObject [

	historyOfTouchedNodes := anObject
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
	self historyOfCollapsedNodes: OrderedCollection new.
	self historyOfTouchedNodes: OrderedCollection new.
]

{ #category : 'testing' }
WSSolver >> isValidToMove: aClass toNode: aNode [
	
	^ self topology isValidToMove: aClass toNode: aNode onGraph: self graph.
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
	self historyOfCollapsedNodes: OrderedCollection new.
	self historyOfTouchedNodes: OrderedCollection new.
	bt := self backtracking.
	self addOneToTotalNumberOfTries.
	
	bt restartFromClassesGraphForSolver: self.

	(bt nOfContradicitonsPerGraph) >= (bt maxNumberOfTriesPerGraph) ifFalse: [ ^ self ].

	bt restartFromEmptyGraphForSolver: self.
	
	bt nOfRegeneratedGraph >= bt maxNumberOfRegeneratedGraph
		ifTrue: [ WSMaxTriesReached signal.  ]
]

{ #category : 'pathReification' }
WSSolver >> reifyWFCPaths [
	"Create the instances of WFCPath"
	self graph createPaths.
	self graph setPathLengths.
	"self graph destroyRandomLoops.
	self graph deleteUselessCrossingFromAllPaths.	
	self graph destroyPathLoops.
	self graph deleteUselessCrossingFromAllPaths."
	self graph mergePathsWithSameID.
	"self graph correctPaths."
	self graph paths keysAndValuesDo: [ :key :value |
		self graph paths at: key put: value first.
	].

	
	
	
	

]

{ #category : 'running' }
WSSolver >> run [
	"Run the WFC algorithm on the graph" 
	
	| performanceMetrics |
	performanceMetrics := WSCurrentMetrics getPerformanceMetrics.
	
	performanceMetrics wfcTime: [ self solveGraph ] timeToRun .
	Transcript show: 'Solution found'; cr.
	
	self topology rebuildClassNodes: self graph.
	performanceMetrics pathReificationTime: [ self reifyWFCPaths ] timeToRun.
	self updateGraphMetrics.
	
	performanceMetrics visualizationTime: [ self createVisualization ] timeToRun
	
	
]

{ #category : 'running' }
WSSolver >> solveGraph [
	"Core method that executes WFC"
	
	Transcript show: 'Execution started'; cr.
	[ self graph allNodesCollapsed ] whileFalse: [ 
		[  
			self step.
			self graph addOneToCollapsedNodes.		
			
		] on: WSContradiction 
		  do: [ 
			self onContradiction ]
	]
]

{ #category : 'running' }
WSSolver >> step [
	"Take a step of the algorithm (select a node to collapse, collapse it and propagate)"
	
	| collapsedNode touchedNodes |
	
	self graph minEntropyHeap ifEmpty: [ self graph restoreMinEntropyHeap ].
	
	collapsedNode := (self graph selectNextNodeToCollapse).
	collapsedNode := collapsedNode collapseTo: (collapsedNode selectInWhichTileToCollapse).
	self historyOfCollapsedNodes add: collapsedNode copyWithoutEdges.
	collapsedNode collapseStep: self historyOfCollapsedNodes size.	
	
	touchedNodes := (self graph propagate: collapsedNode).
	self historyOfTouchedNodes add: (self copyOfNodesWithoutEdges: touchedNodes).
]

{ #category : 'accessing' }
WSSolver >> topology [

	^ topology
]

{ #category : 'accessing' }
WSSolver >> topology: anObject [

	topology := anObject
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
