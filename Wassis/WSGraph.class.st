"
The graph structure on which the WFC algorithm is executed
"
Class {
	#name : 'WSGraph',
	#superclass : 'WSObject',
	#instVars : [
		'nodes',
		'entropyHeap',
		'paths',
		'numberOfNodes',
		'numberOfCollapsedNodes',
		'topology',
		'structure'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'deprecated' }
WSGraph class >> collapseClassPathExitsFor: classCollapsedNodes [
	"Force the exits of the paths to be collapsed after the classes nodes"

	classCollapsedNodes do: [ :eachClassNode |
		| dir |
		dir := eachClassNode tileInWhichCollapsed edges select: [ :eachEdge | eachEdge first ~= WSConfig emptyEdgeSymbol ].
		
		dir keysDo: [ :eachDir | 
			| neighbourNode |
			neighbourNode := eachClassNode neighbourAtDirection: eachDir.
			neighbourNode 
				keepTilesWithIDin: (( 1 to: 6 ) asArray);
				entropy: -1;
				sumOfWeights: 0;
				sumOfWeightsLog: 0.			
		]
	]
]

{ #category : 'creation' }
WSGraph class >> createClassNodesFrom: collapsedNodes [

	| dict |
	dict := Dictionary new.
	
	collapsedNodes do: [ :eachNode | 
		dict at: (eachNode tileInWhichCollapsed wsClass) put: eachNode 
	].
	
	^ dict

]

{ #category : 'creation' }
WSGraph class >> createInitialHeapFrom: collapsedClassNodes [
	"Create the initial heap for the execution. A min heap or a max heap can be chosen"
	
	 | initialHeap initValue |
	
	WSConfig isMinHeap 
		ifTrue: [ 
			initValue := SmallInteger minVal.
			initialHeap := Heap new.
		]
		ifFalse: [ 
			initValue := SmallInteger maxVal.
			initialHeap := Heap sortBlock: [ :a :b | a >= b ].
		].
	
	collapsedClassNodes do: [ :eachNode | eachNode entropy: initValue; sumOfWeights: initValue; sumOfWeightsLog: initValue ].
	initialHeap addAll: collapsedClassNodes.
	
	^ initialHeap 
]

{ #category : 'fuel support' }
WSGraph class >> fuelIgnoredInstanceVariableNames [

    ^ #('topology' 'entropyHeap')
]

{ #category : 'instance creation' }
WSGraph class >> newWithStructure: aStructure andCollapsedNodes: collapsedNodes andTopology: aTopology [
	
	| allNodes |
	allNodes := aStructure getFlattenedNodes.
	
	"self collapseClassPathExitsFor: collapsedNodes."

	^ self new
		structure: aStructure;
		nodes: allNodes;
		topology: aTopology;
		numberOfNodes: allNodes size;
		entropyHeap: (self createInitialHeapFrom: collapsedNodes).

]

{ #category : 'collapse' }
WSGraph >> addOneToCollapsedNodes [

	self numberOfCollapsedNodes: (self numberOfCollapsedNodes + 1)
]

{ #category : 'path reification' }
WSGraph >> adjacentPathNodeIn: aPath for: aNode [
    "Returns the node in aPath adjacent to aNode, or nil if the path is a single point"
    | idx pathNodes |
    pathNodes := aPath nodes asOrderedCollection .
    pathNodes size < 2 ifTrue: [ ^ nil ].
    
    idx := pathNodes indexOf: aNode.
    idx = 1 ifTrue: [ ^ pathNodes second ].
    idx = pathNodes size ifTrue: [ ^ pathNodes at: pathNodes size - 1 ].
    ^ pathNodes at: idx + 1
]

{ #category : 'collapse' }
WSGraph >> allNodesCollapsed [
	"Returns true if all nodes in the graph have collapsed, otherwise false"

	^ self numberOfNodes = self numberOfCollapsedNodes
]

{ #category : 'path reification' }
WSGraph >> assignFirstAndLastNodesFor: aPath [
	"Assign or reassign firstNodes and lastNodes to a path based on its source and destination classes"
	
	| pathNodes sourceNodes destinationNodes |
	pathNodes := aPath nodes asSet.
	
	sourceNodes := 
		(aPath sourceClasses flatCollect: 
			[ :eachClassNode | 
				eachClassNode outgoingEdges collect: 
					[ :edge | edge target ] ]) asSet.
			
	destinationNodes := 
		(aPath destinationClasses flatCollect: 
			[ :eachClassNode | 
				eachClassNode outgoingEdges collect: 
					[ :edge | edge target ] ]) asSet.

	aPath firstNodes: OrderedCollection new.
	aPath lastNodes: OrderedCollection new.
	
	pathNodes do: [ :eachPathNode | 
		(sourceNodes includes: eachPathNode) ifTrue: [ aPath addFirstNode: eachPathNode ].	
		(destinationNodes includes: eachPathNode) ifTrue: [ aPath addLastNode: eachPathNode ].	
	]
	


]

{ #category : 'deprecated' }
WSGraph >> assignSourceAndDestination: aPath [
	"Assign sources and destination to a path"
	
    | touchedClasses touchedWSClasses |
    touchedClasses := aPath touchedClasses.
    touchedWSClasses := touchedClasses collect: [ :node | node tileInWhichCollapsed wsClass ].
    
    touchedClasses do: [ :aClassNode |
        | wsClass isSource |
        wsClass := aClassNode tileInWhichCollapsed wsClass.
        isSource := wsClass connectedWith anySatisfy: [ :conn |
            touchedWSClasses includes: conn target ].
        isSource
            ifTrue: [ aPath addSourceClass: aClassNode ]
            ifFalse: [ aPath addDestinationClass: aClassNode ] ]
]

{ #category : 'path reification' }
WSGraph >> assignSourceAndDestinationFor: aPath [
	"Assign correct sources and destinations to a path"
	
	| allClassNodes allWSClasses |
	allClassNodes := aPath touchedClasses asSet.
	
	allWSClasses := (allClassNodes collect: [ :node | node tileInWhichCollapsed wsClass ]) asSet.
	
	aPath sourceClasses: OrderedCollection new.
	aPath destinationClasses: OrderedCollection new.
	
	allClassNodes do: [ :aClassNode |
		| wsClass isSource |
		wsClass := aClassNode tileInWhichCollapsed wsClass.
		
		isSource := wsClass connectedWith anySatisfy: [ :conn |
			(allWSClasses includes: conn target) and: [ conn target ~= wsClass ] 
		].
	
		isSource
			ifTrue: [ aPath addSourceClass: aClassNode ]
			ifFalse: [ aPath addDestinationClass: aClassNode ] 
	].
]

{ #category : '2DGrid' }
WSGraph >> atRow: row atColumn: column [
	
	^ self structure atRow: row atColumn: column 
]

{ #category : 'path optimization' }
WSGraph >> borderNodeOf: aFootprint adjacentTo: aPathNode [
    "Return the border node of aFootprint that is adjacent to aPathNode"
    
    ^ (aFootprint borderNodes: self topology)
        detect: [ :aNode | aNode outgoingEdges anySatisfy: [ :eachEdge | eachEdge target = aPathNode ] ]
]

{ #category : 'path optimization' }
WSGraph >> buildDijkstraEdgesFor: pathID onNodes: dijkstraNodes [
	"Build the weighted edge collection for Dijkstra, avoiding redundant structures"
	
	| dijkstraEdges |
	dijkstraEdges := OrderedCollection new.
	
	dijkstraNodes do: [ :eachNode |
		eachNode outgoingEdges do: [ :eachEdge |
			| targetNode |
			targetNode := eachEdge target.
			
			((dijkstraNodes includes: targetNode) and: [ 
				(self shouldSkipEdge: eachEdge from: eachNode to: targetNode forPath: pathID) not ])
					ifTrue: [
						| weight |
						weight := (targetNode isPathNode and: [ (targetNode tileInWhichCollapsed pathIDs includes: pathID) not ])
							ifTrue: [ WSConfig dijkstraTraversingPathWeight ]
							ifFalse: [ 1 ].
							
						dijkstraEdges add: { eachNode . targetNode . weight } ] ] ].
						
	^ dijkstraEdges
]

{ #category : 'path optimization' }
WSGraph >> buildDijkstraEdgesFor: pathID onNodes: dijkstraNodes zeroNodes: zeroNodes [
	"Build the weighted edge collection for Dijkstra, managing zero-weight backbone snapping and foreign path penalties"
	
	| dijkstraEdges |
	dijkstraEdges := OrderedCollection new.
	
	dijkstraNodes do: [ :eachNode |
		(eachNode respondsTo: #outgoingEdges) ifTrue: [
			eachNode outgoingEdges do: [ :eachEdge |
				| targetNode |
				targetNode := eachEdge target.
				
				((dijkstraNodes includes: targetNode) and: [ 
					(self shouldSkipEdge: eachEdge from: eachNode to: targetNode forPath: pathID) not ])
						ifTrue: [
							| weight |
							(zeroNodes includes: targetNode) 
								ifTrue: [ weight := 0 ]
								ifFalse: [
									(targetNode isPathNode and: [ (targetNode tileInWhichCollapsed pathIDs includes: pathID) not ])
										ifTrue: [ weight := WSConfig dijkstraTraversingPathWeight ]
										ifFalse: [ weight := 1 ] ].
							
							dijkstraEdges add: { eachNode . targetNode . weight } ] ] ] ].
							
	^ dijkstraEdges
]

{ #category : 'path optimization' }
WSGraph >> calculateBestConnectionsFrom: optimalSet toClasses: touchedClasses [
	"Find the single best connection point for each logical class to avoid multiple attachments"
	
	| classToEdges chosen allTouchedClassNodes |
	classToEdges := Dictionary new.
	allTouchedClassNodes := (touchedClasses flatCollect: [ :eachNode | eachNode footPrint borderNodes: self topology ]) asSet.
	optimalSet do: [ :pNode |
		pNode outgoingEdges do: [ :edge |
			(edge target isClassNode and: [ allTouchedClassNodes includes: edge target ]) ifTrue: [
				| wsClass |
				wsClass := edge target tileInWhichCollapsed wsClass.
				(classToEdges at: wsClass ifAbsentPut: [ OrderedCollection new ]) 
					add: (pNode -> edge target).
			]
		]
	].
	
	chosen := Set new.
	
	classToEdges valuesDo: [ :edges |
		| bestEdge |
		bestEdge := edges detectMin: [ :assoc | 
			assoc key outgoingEdges count: [ :e | optimalSet includes: e target ] 
		].
		chosen add: bestEdge.
	].
	
	^ chosen
]

{ #category : 'path reification' }
WSGraph >> calculatePathMetrics [
	"Calculate and assign the efficiency metrics for all paths"
	
	self paths do: [ :eachPath | 
		| optimalNodes |
		optimalNodes := self computeShortestPathFor: eachPath.
				
		(optimalNodes size < eachPath length) 
			ifTrue: [  
				eachPath 
					efficiency: (optimalNodes size / eachPath length);
					shortestPath: optimalNodes
			]
			ifFalse: [ 
				eachPath 
				efficiency: 1; 
				shortestPath: eachPath nodes 
			].
	]
]

{ #category : 'path optimization' }
WSGraph >> clearPath: aPath [
	"Clear a path replacing each tile with the empty tile"

	| emptyTile touchedNodes |
	touchedNodes := OrderedCollection new.
	emptyTile := self topology createEmptyTile.

	aPath nodes do: [ :eachNode |
		touchedNodes add: eachNode.
		eachNode tileInWhichCollapsed isCrossingTile 
			ifTrue: [ 
				| newDirToPathID |
                newDirToPathID := eachNode tileInWhichCollapsed edges
                    reject: [ :edge | edge includes: aPath pathID ].
					newDirToPathID keysAndValuesDo: [ :key :value | newDirToPathID at: key put: value first ].
				eachNode collapseTo: (self topology tileset tileForDirections: newDirToPathID)
			]
			ifFalse: [ 
				eachNode collapseTo: emptyTile. ]	
	].

	aPath 
		nodes: OrderedCollection new;
		length: Float infinity;
		firstNodes: OrderedCollection new;
		lastNodes: OrderedCollection new.
	
	^ touchedNodes 
	
]

{ #category : 'path optimization' }
WSGraph >> clearPathWithID: anID [

	^ self clearPath: (self paths at: anID)
]

{ #category : 'path optimization' }
WSGraph >> collapseNode: aNode toPathTile: pathID between: prevNode and: nextNode [
    "Collapse a node to the right path tile, preserving existing path directions"

    | newDirs dirToPathID |
    
    newDirs := (aNode outgoingEdges
        select: [ :eachEdge | eachEdge target = prevNode or: [ eachEdge target = nextNode ] ]
        thenCollect: [ :eachEdge | eachEdge direction ]) asOrderedCollection.
    
    dirToPathID := aNode tileInWhichCollapsed edges veryDeepCopy.
	 dirToPathID  keysAndValuesDo: [ :key : value |
		dirToPathID at: key put: value first.
	 ].

    newDirs do: [ :dir | dirToPathID at: dir put: pathID ].
    
    ^ aNode collapseTo: (self topology tileset tileForDirections: dirToPathID)
]

{ #category : 'collapse' }
WSGraph >> collectFootprintFrom: aNode size: n [
	
	^ self structure collectFootprintFrom: aNode size: n
]

{ #category : 'path reification' }
WSGraph >> computeShortestPathFor: aPath [
    "Compute the shortest path nodes for aPath. Returns an OrderedCollection of nodes."
    aPath touchedClasses size = 2
        ifTrue: [
            | shortestPath |
            shortestPath := self
                findOptimalPathWithID: aPath pathID
                andClasses: (aPath sourceClasses first tileInWhichCollapsed wsClass)
                          -> (aPath destinationClasses first tileInWhichCollapsed wsClass).
            ^ shortestPath asOrderedCollection ]
        ifFalse: [
            | pairs allPaths backbone optimalNodes remainingClasses bestAssociation backbonePair |
            pairs := aPath sourceClasses flatCollect: [ :src |
                aPath destinationClasses collect: [ :dst |
                    (src tileInWhichCollapsed wsClass) -> (dst tileInWhichCollapsed wsClass) ] ].
            allPaths := pairs collect: [ :pair |
                pair -> (self findOptimalPathWithID: aPath pathID andClasses: pair) ].
				bestAssociation := allPaths detectMax: [ :eachAssociation | eachAssociation value size ].
				backbonePair := bestAssociation key.
            backbone := bestAssociation value.
            optimalNodes := (backbone ifNil: [ OrderedCollection new ]) asSet.

				remainingClasses := ((aPath touchedClasses collect: [ :node | node tileInWhichCollapsed wsClass ]) asSet)
					reject: [ :eachClass | eachClass = backbonePair key or: [ eachClass = backbonePair value ] ].
				remainingClasses do: [ :eachClass |
					| p |
					p := self
						findOptimalPathWithID: aPath pathID
						fromClass: eachClass
						toBackbone: optimalNodes.
				optimalNodes addAll: p ].
            ^ optimalNodes asOrderedCollection ]
]

{ #category : 'deprecated' }
WSGraph >> correctPaths [
	"Check that each node of a path is collapsed into the right tile, if not, correct it"
	
	self paths keysAndValuesDo: [ :key :value |
		self paths at: key put: value first.
	].
	self paths do: [ :eachPath | eachPath nodes: eachPath nodes asOrderedCollection ].

	self paths keysAndValuesDo: [ :key :value |
		value nodes do: [ :eachNode |
			| directionsToCheck pathID |
			pathID := value pathID.
			directionsToCheck := OrderedCollection new.
			
			eachNode outgoingEdges do: [ :eachEdge |
				| tile |
				tile := eachEdge target tileInWhichCollapsed.
				((tile isPathTile) and: [ tile pathID = pathID ]) ifTrue: [ 
					directionsToCheck add: eachEdge direction
				].
				((tile isClassTile) and: [ (tile edges at: eachEdge reverseEdge direction) includes: pathID ]) ifTrue: [ 
					directionsToCheck add: eachEdge direction
				]
			].
			eachNode collapseTo: (self topology tileset tileForDirections: directionsToCheck pathID: pathID)
		]
	].
]

{ #category : 'path reification' }
WSGraph >> createPaths [
    "Create the instances of wsPaths"
    
    | pathIDs visitedNodesPerPath |
    pathIDs := self topology allPathIDs .
    
    visitedNodesPerPath := Dictionary new.
    pathIDs do: [ :pathID | 
        self paths at: pathID put: OrderedCollection new.
        visitedNodesPerPath at: pathID put: Set new ].
    
    self topology classFootprint do: [ :eachFootprint |
        (eachFootprint borderNodes: self topology) do: [ :eachClassNode |
            | tileEdges |
            tileEdges := eachClassNode tileInWhichCollapsed edges.
            
            eachClassNode outgoingEdges do: [ :eachEdge |
                | dir pathID |
                dir := eachEdge direction.
                pathID := (tileEdges at: dir ifAbsent: [ #() ])
                    detect: [ :each | pathIDs includes: each ]
                    ifNone: [ nil ].
                
                (pathID notNil and: [ ((visitedNodesPerPath at: pathID) includes: eachEdge target) not ]) ifTrue: [
                    | newPath visited |
                    newPath := WSPath withID: pathID.
                    newPath addTouchedClass: eachClassNode.
                    
                    visited := Set with: eachClassNode.
                    self followPath: newPath
                        from: eachEdge
                        visited: visited
                        pathID: pathID.
                   
                    (visitedNodesPerPath at: pathID) addAll: newPath nodes.
                    
                    self assignSourceAndDestinationFor: newPath.
						  self assignFirstAndLastNodesFor: newPath.
                    (self paths at: pathID) add: newPath ] ] ] ]
]

{ #category : 'deprecated' }
WSGraph >> deleteUselessCrossingFromAllPaths [
	"While refining the paths, some crossing that are not needed remains. This method erases them from all paths"

	self paths do: [ :eachCollectionOfPath | 
		eachCollectionOfPath do: [ :eachPath | 
			self deleteUselessCrossingFromPath: eachPath 
		]
	]
]

{ #category : 'deprecated' }
WSGraph >> deleteUselessCrossingFromPath: aPath [
    "While refining the paths, some crossing that are not needed remains. This method erases them"
    | pathID |
    pathID := aPath pathID.
    
    aPath crossingNodes do: [ :eachNode | 
            | validDirections needsCollapse |
            validDirections := OrderedCollection new.
            needsCollapse := false.
            
            eachNode tileInWhichCollapsed edges keysAndValuesDo: [ :dir :symbols |
                | neighbourTile oppositeDir |
                neighbourTile := (eachNode neighbourAtDirection: dir) tileInWhichCollapsed.
                oppositeDir := self topology oppositeDirections at: dir.
                
                 ((neighbourTile edges at: oppositeDir) includes: symbols first)
                        ifTrue: [ validDirections add: dir ]
                        ifFalse: [ needsCollapse := true ] ] .
            
            needsCollapse ifTrue: [ 
                | correctTile |
                correctTile := self topology tileset tileForDirections: validDirections pathID: pathID.
                eachNode collapseTo: correctTile ] ] 
]

{ #category : 'deprecated' }
WSGraph >> destroyPathLoops [
	"Destroy the paths that degenerated in a loop and are connected to only 1 class"
	
	| emptyTile |
    emptyTile := self topology createEmptyTile.
	self paths do: [ :collectionOfPaths | 
		collectionOfPaths do: [ :eachPath | 
			eachPath touchedClasses size == 1 ifTrue: [ 
				eachPath nodes do: [ :eachNode | 
					((eachNode ~= eachPath firstNodes) and: [ eachNode isNotCrossingNode ]) ifTrue: [ 
						eachNode collapseTo: emptyTile 
					]
				].
				eachPath nodes: (OrderedCollection with: eachPath firstNodes)
			]
		]
	]
	
]

{ #category : 'deprecated' }
WSGraph >> destroyRandomLoops [
	"Destroy the paths that are loop and are not connected to any class"

    | emptyTile |
    emptyTile := self topology createEmptyTile.
    self nodes do: [ :eachNode |
        | tile |
        tile := eachNode tileInWhichCollapsed.
        tile isPathTile ifTrue: [
            | allPaths isInAPath |
				allPaths := (tile pathIDs collect: [ :eachPathID | self paths at: eachPathID ]) flattened.
            isInAPath := allPaths anySatisfy: [ :eachPath | eachPath nodes includes: eachNode ].
            isInAPath ifFalse: [
                eachNode collapseTo: emptyTile ] ] ]
]

{ #category : 'accessing' }
WSGraph >> entropyHeap [

	^ entropyHeap
]

{ #category : 'accessing' }
WSGraph >> entropyHeap: anObject [

	entropyHeap := anObject
]

{ #category : 'deprecated' }
WSGraph >> findOptimalPathWithID2: pathID andClasses: classes [
	"Find optimal path between two classes. May change the exit for each class"

	| footprint1 footprint2 shortestPath |
	footprint1 := (self topology classFootprint at: classes key).
	footprint2 := (self topology classFootprint at: classes value).

	shortestPath := nil.
	
   (footprint1 borderNodes: self topology) do: [ :node1 |
   		(footprint2 borderNodes: self topology) do: [ :node2 |
      		| candidate |
         candidate := self
         		runDijkstraFrom: node1
            to: node2
            withExtraNodes: { node1. node2 }
            pathID: pathID.
			
			candidate isNotEmpty ifTrue: 
				[ (shortestPath isNil or: [ candidate size < shortestPath size ])
                ifTrue: [  shortestPath := candidate ] ] ] ].

    shortestPath removeFirst.
    shortestPath removeLast.

    ^ shortestPath
]

{ #category : 'deprecated' }
WSGraph >> findOptimalPathWithID: pathID [
	"Find optimal path between two classes. Does NOT change the exit for each class"
	
    | pathObject shortestPath |

    pathObject := self paths at: pathID.

    shortestPath := self 
        runDijkstraFrom: pathObject firstNodes 
        to: pathObject lastNodes 
        withExtraNodes: #() 
        pathID: pathID.

    ^ shortestPath
]

{ #category : 'path optimization' }
WSGraph >> findOptimalPathWithID: pathID andClasses: classes [
	"Find optimal path between two classes. Reuses the graph structure to boost performance."

	| footprint1 footprint2 border1 border2 dijkstraNodes dijkstraEdges shortestPath |
	footprint1 := self topology classFootprint at: classes key.
	footprint2 := self topology classFootprint at: classes value.

	border1 := footprint1 borderNodes: self topology.
	border2 := footprint2 borderNodes: self topology.

	dijkstraNodes := Set new.
	dijkstraNodes addAll: border1; addAll: border2.
	dijkstraNodes addAll: (self nodes flattened select: [ :eachNode | eachNode isNotClassNode ]).

	dijkstraEdges := self buildDijkstraEdgesFor: pathID onNodes: dijkstraNodes.

	shortestPath := nil.

	border1 do: [ :node1 |
		| dijkstra |
		dijkstra := AIDijkstra new.
		dijkstra nodes: dijkstraNodes; edges: dijkstraEdges from: #first to: #second weight: #third.
		
		border2 do: [ :node2 |
			| candidate |
			candidate := (dijkstra runFrom: node1 to: node2) asOrderedCollection.
			
			candidate isNotEmpty ifTrue: [ 
				(shortestPath isNil or: [ candidate size < shortestPath size ])
					ifTrue: [ shortestPath := candidate ] ] ] ].

	(shortestPath notNil and: [ shortestPath size >= 2 ]) ifTrue: [
		shortestPath removeFirst.
		shortestPath removeLast ].

	^ shortestPath ifNil: [ OrderedCollection new ]
]

{ #category : 'path optimization' }
WSGraph >> findOptimalPathWithID: pathID fromClass: aClass toBackbone: backboneNodes [
	"Find the optimal path between a class and the current backbone using a virtual target trick"
	
	| footprint borderNodes dijkstraNodes dijkstraEdges virtualTarget shortestPath |
	backboneNodes isEmpty ifTrue: [ ^ #() ].
	
	footprint := self topology classFootprint at: aClass.
	borderNodes := footprint borderNodes: self topology.
	
	(borderNodes anySatisfy: [ :n | backboneNodes includes: n ]) ifTrue: [ ^ #() ].

	dijkstraNodes := Set new.
	dijkstraNodes addAll: borderNodes; addAll: backboneNodes.
	dijkstraNodes addAll: (self nodes flattened select: [ :eachNode | eachNode isNotClassNode ]).
	
	virtualTarget := Object new.
	dijkstraNodes add: virtualTarget.

	dijkstraEdges := self buildDijkstraEdgesFor: pathID onNodes: dijkstraNodes zeroNodes: backboneNodes.
	
	backboneNodes do: [ :bNode |
		dijkstraEdges add: { bNode . virtualTarget . 0 } ].

	shortestPath := nil.

	borderNodes do: [ :node1 |
		| dijkstra candidate |
		dijkstra := AIDijkstra new.
		dijkstra nodes: dijkstraNodes; edges: dijkstraEdges from: #first to: #second weight: #third.
		
		candidate := (dijkstra runFrom: node1 to: virtualTarget) asOrderedCollection.
		
		candidate isNotEmpty ifTrue: [
			candidate removeLast. 
			(shortestPath isNil or: [ candidate size < shortestPath size ])
				ifTrue: [ shortestPath := candidate ] ] ].

	shortestPath ifNil: [ ^ #() ].
	
	shortestPath isNotEmpty ifTrue: [ shortestPath removeFirst ].

	^ shortestPath
]

{ #category : 'path reification' }
WSGraph >> followPath: aPath from: anEdge visited: visited pathID: aPathID [
    | node tile reverseDir |
    node := anEdge target.
    (visited includes: node) ifTrue: [ ^ self ].
    visited add: node.
    
    tile := node tileInWhichCollapsed.
    
    tile isClassTile ifTrue: [
        aPath addTouchedClass: node.
        ^ self ].
    
    (tile isPathTile and: [ tile pathIDs includes: aPathID ]) ifTrue: [
        aPath addNode: node.
        reverseDir := anEdge reverseEdge direction.
        tile edges keysAndValuesDo: [ :dir :pathIDs |
            (dir ~= reverseDir and: [ pathIDs includes: aPathID ]) ifTrue: [
                node outgoingEdges do: [ :eachEdge |
                    eachEdge direction = dir ifTrue: [
                        self followPath: aPath
                            from: eachEdge
                            visited: visited
                            pathID: aPathID ] ] ] ].
        ^ self ].
]

{ #category : 'serialization' }
WSGraph >> fuelAfterMaterialization [
	"Reinstall the sort block after Fuel deserialization"

	entropyHeap := WSConfig isMinHeap
		ifTrue: [ Heap new ]
		ifFalse: [ Heap sortBlock: [ :a :b | a >= b ] ]
]

{ #category : 'path optimization' }
WSGraph >> getAdjacentClassForNode: aNode [
	
    ^ (aNode outgoingEdges 
        detect: [ :eachEdge | eachEdge target isClassNode ]
        ifNone: [ nil ]) 
        ifNotNil: [ :e | e target ]
]

{ #category : 'accessing' }
WSGraph >> getFlattenedNodes [

	^ self nodes flattened
]

{ #category : '2DGrid' }
WSGraph >> getNeighboursOf: aNode atLevel: level [
	
	^ self structure getNeighboursOf: aNode atLevel: level
]

{ #category : 'accessing' }
WSGraph >> getPathNodes [
	"Returns an ordered collection of the path nodes"
	
	^ self paths flatCollect: [ :eachPath | eachPath nodes ]

]

{ #category : 'initialization' }
WSGraph >> initialize [ 
	
	super initialize.
	self paths: Dictionary new.
	self numberOfCollapsedNodes: 0
	
]

{ #category : '2DGrid' }
WSGraph >> isInBoundsRow: row column: col [

	^ self structure isInBoundsRow: row column: col 
]

{ #category : 'path reification' }
WSGraph >> mergePath: pathA withPath: pathB usingConnection: connectionNodes pathID: pathID [
	"Merge two paths into one, collapsing the connection nodes as path tiles."
	| mergedPath connectionMiddle |
	
	mergedPath := WSPath withID: pathID.
	
	2 to: connectionNodes size - 1 do: [ :i |
		| prevNode currNode nextNode |
		prevNode := connectionNodes at: i - 1.
		currNode := connectionNodes at: i.
		nextNode := connectionNodes at: i + 1.
		
		self collapseNode: currNode
			toPathTile: pathID
			between: prevNode
			and: nextNode ].
	
	connectionNodes size > 1 ifTrue: [
		| firstConn secondConn lastConn secondLastConn adjA adjB |
		firstConn := connectionNodes first.
		secondConn := connectionNodes second.
		lastConn := connectionNodes last.
		secondLastConn := connectionNodes at: connectionNodes size - 1.
		
		adjA := (self adjacentPathNodeIn: pathA for: firstConn).
		self collapseNode: firstConn
			toPathTile: pathID
			between: (adjA ifNil: [ firstConn ])
			and: secondConn.
		
		adjB := (self adjacentPathNodeIn: pathB for: lastConn).
		self collapseNode: lastConn
			toPathTile: pathID
			between: secondLastConn
			and: (adjB ifNil: [ lastConn ]) ].
	
	connectionMiddle := connectionNodes copyFrom: 2 to: connectionNodes size - 1.
	pathA nodes do: [ :node | mergedPath addNode: node ].
	connectionMiddle do: [ :node | mergedPath addNode: node].
	pathB nodes do: [ :node | mergedPath addNode: node ].
	
	mergedPath touchedClasses: (pathA touchedClasses , pathB touchedClasses) asSet asOrderedCollection.
	
	self assignSourceAndDestinationFor: mergedPath.
	self assignFirstAndLastNodesFor: mergedPath.
	
	^ mergedPath
]

{ #category : 'path reification' }
WSGraph >> mergePathsWithSameID [
	"If two paths with the same ID are not connected, merge them"

    self paths keysAndValuesDo: [ :pathID :collectionOfPaths |
        [ collectionOfPaths size > 1 ] whileTrue: [
            | bestPair bestDistance bestShortestPath dijkstraNodes |
            bestDistance := Float infinity.
            bestPair := nil.
            bestShortestPath := nil.

				dijkstraNodes := Set new.
    
			   dijkstraNodes addAll: (self nodes select: [ :eachNode | 
					eachNode isNotClassNode 
					and: ([eachNode isNotCrossingNode]) ]).

            collectionOfPaths doWithIndex: [ :pathA :i |
                collectionOfPaths doWithIndex: [ :pathB :j |
                    (i < j) ifTrue: [
                        pathA nodes do: [ :startNode |
                            pathB nodes do: [ :endNode |
                                | path  |
										 (startNode isNotCrossingNode and: [ endNode isNotCrossingNode ]) ifTrue: [  
						
                                path := self
                                    runDijkstraFrom: startNode
                                    to: endNode
											  onNodes: dijkstraNodes.
                                (path notEmpty and: [ path size < bestDistance ]) ifTrue: [
                                    bestDistance := path size.
                                    bestPair := pathA -> pathB.
                                    bestShortestPath := path ] ] ] ] ] ] ].

            bestPair ifNotNil: [
                | pathA pathB mergedPath |
                pathA := bestPair key.
                pathB := bestPair value.
                mergedPath := self mergePath: pathA withPath: pathB usingConnection: bestShortestPath pathID: pathID.
                collectionOfPaths remove: pathA; remove: pathB; add: mergedPath.
					  ] ] ]
]

{ #category : 'accessing' }
WSGraph >> nodes [

	^ nodes
]

{ #category : 'accessing' }
WSGraph >> nodes: anObject [

	nodes := anObject
]

{ #category : 'accessing' }
WSGraph >> numberOfCollapsedNodes [

	^ numberOfCollapsedNodes
]

{ #category : 'accessing' }
WSGraph >> numberOfCollapsedNodes: anObject [

	numberOfCollapsedNodes := anObject
]

{ #category : 'accessing' }
WSGraph >> numberOfNodes [

	^ numberOfNodes
]

{ #category : 'accessing' }
WSGraph >> numberOfNodes: anObject [

	numberOfNodes := anObject
]

{ #category : 'path optimization' }
WSGraph >> optimizeAllPathsAllowingExitModifications: aBoolean [
	"Optimize all the paths, decide if you allow exit changing"

	self optimizePathsWithPathIDs: (self topology allPathIDs) allowExitsModification: aBoolean 
]

{ #category : 'path optimization' }
WSGraph >> optimizePaths: pathIDs [
	"Optimize all the paths which pathID is in pathIDs"
	
	| touchedNodes |
	touchedNodes := Set new.

	pathIDs do: [ :eachPathID |
		
		| generatedPath optimalPath |
		generatedPath := self paths at: eachPathID.		
		optimalPath := self computeShortestPathFor: generatedPath.
		touchedNodes addAll: 
			(self substituteIfShorter: optimalPath with: generatedPath).
	]. 

	^ touchedNodes
]

{ #category : 'deprecated' }
WSGraph >> optimizePathsWithPathIDs: pathIDs allowExitsModification: aBoolean [
	"Optimize all the paths which pathID is in pathIDs"

	aBoolean 
		ifTrue: [ ^ self optimizePaths: pathIDs ] 
		ifFalse: [ ^ self optimizePathsWithoutExitModification: pathIDs ] 
]

{ #category : 'deprecated' }
WSGraph >> optimizePathsWithoutExitModification: pathIDs [
	"Optimize all the paths which pathID is in pathIDs"
	
	| touchedNodes |
	touchedNodes := Set new.

	pathIDs do: [ :eachPathID | 
		| generatedPath optimalPath |
		generatedPath := (self paths at: eachPathID).
		optimalPath := self findOptimalPathWithID: eachPathID.
		
		touchedNodes addAll: generatedPath nodes; addAll: optimalPath.
		
		self substituteIfShorter: optimalPath for: generatedPath updatingExits: false.		
	 ].

	^ touchedNodes 
]

{ #category : 'accessing' }
WSGraph >> paths [

	^ paths
]

{ #category : 'accessing' }
WSGraph >> paths: anObject [

	paths := anObject
]

{ #category : 'propagating' }
WSGraph >> propagate: aNode [
	"Propagate the constraint of a collapsed node to the graph"
	| queue touchedNodes |
   queue := OrderedCollection with: aNode.
   touchedNodes := Set new.
    
   [ queue isEmpty ] whileFalse: [
   		| currentNode |
      currentNode := queue removeFirst.
      currentNode outgoingEdges do: [ :eachEdge |
      		(self propagateEdge: eachEdge from: currentNode into: queue) 
         		ifNotNil: [ :neighbour | touchedNodes add: neighbour ] ] ].
    
    self updateMinEntropyHeap: touchedNodes.

	^ touchedNodes 
	
]

{ #category : 'propagating' }
WSGraph >> propagateEdge: eachEdge from: currentNode into: queue [
    "Returns the neighbour node if it was affected by the propagation, nil otherwise"

    | neighbourNode removedTiles |
    neighbourNode := eachEdge target.
    neighbourNode isCollapsed ifTrue: [ ^ nil ].
    
    removedTiles := neighbourNode reducePossibilitiesBasedOn: currentNode withConnectionEdge: eachEdge.
    neighbourNode possibleTiles ifEmpty: [ WSContradiction signal ].
    removedTiles ifEmpty: [ ^ nil ].
    
    neighbourNode updateEntropyRemovingTiles: removedTiles.
    queue add: neighbourNode.

    ^ neighbourNode
]

{ #category : 'propagating' }
WSGraph >> propagatePathIDResolutionFrom: aCollapsedNode [
    "After collapsing to a resolved path tile, force neighbours with placeholders to re-resolve. Returns all nodes that were updated"
	 
	| queue resolvedNodes |
	queue := OrderedCollection with: aCollapsedNode.
	resolvedNodes := OrderedCollection new.
	
	[ queue isEmpty ] whileFalse: [ 
		(queue removeFirst) outgoingEdges do: [ :eachEdge |
        | neighbour |
        neighbour := eachEdge target.
        (neighbour isCollapsed and: [ neighbour isPathNode and: [ neighbour tileInWhichCollapsed isPlaceholderTile ] ])
            ifTrue: [
                | updatedTile |
                updatedTile := (neighbour resolvePathTile: neighbour tileInWhichCollapsed).
                updatedTile ~= (neighbour tileInWhichCollapsed) 
						ifTrue: [
                    neighbour
                        possibleTiles: (Set with: updatedTile);
                        tileInWhichCollapsed: updatedTile.

						 resolvedNodes add: neighbour.
						 updatedTile isResolvedTile ifTrue: [ queue add: neighbour ] 
						] 
				] 
		  ] 
	 ].

	^ resolvedNodes 
	

]

{ #category : 'deprecated' }
WSGraph >> reassignSourceDestination: aPath [
    "Reassign source and destination after the merge"
    | allTouched |
    allTouched := (aPath sourceClasses , aPath destinationClasses) asSet.
    aPath sourceClasses: OrderedCollection new.
    aPath destinationClasses: OrderedCollection new.
    allTouched do: [ :aClassNode |
        | wsClass isSource |
        wsClass := aClassNode tileInWhichCollapsed wsClass.
        isSource := wsClass connectedWith anySatisfy: [ :conn |
            allTouched anySatisfy: [ :other | 
                other ~= aClassNode and: [ conn target = other tileInWhichCollapsed wsClass ] ] ].
        isSource
            ifTrue: [ aPath addSourceClass: aClassNode ]
            ifFalse: [ aPath addDestinationClass: aClassNode ] ]
]

{ #category : 'deprecated' }
WSGraph >> resolveAllPlaceholders [
	"Iterates over the graph resolving all placeholders inherited from collapsed neighbours"
	
	| nodesWithPlaceholders |
	
	nodesWithPlaceholders := (self nodes select: [ :eachNode | 
		eachNode tileInWhichCollapsed edges anySatisfy: [ :eachEdge | 
			WSConfig isPlaceholder: eachEdge first ] ]) asOrderedCollection.

	[ nodesWithPlaceholders isEmpty ] whileFalse: [
		| currentNode currentTile resolvedTile |
		currentNode := nodesWithPlaceholders removeFirst.
		currentTile := currentNode tileInWhichCollapsed.
		resolvedTile := currentNode resolvePathTile: currentTile.

		resolvedTile = currentTile
			ifFalse: [
				currentNode
					possibleTiles: (Set with: resolvedTile);
					tileInWhichCollapsed: resolvedTile.
				
				(resolvedTile edges anySatisfy: [ :e | WSConfig isPlaceholder: e first ])
					ifTrue: [ nodesWithPlaceholders addLast: currentNode ].
					
				currentNode outgoingEdges do: [ :eachEdge | 
					| neighbour |
					neighbour := eachEdge target.
					
					(neighbour isCollapsed and: [ 
						(nodesWithPlaceholders includes: neighbour) not and: [ 
							neighbour tileInWhichCollapsed edges anySatisfy: [ :sym | WSConfig isPlaceholder: sym first ] ] ])
						ifTrue: [ nodesWithPlaceholders addLast: neighbour ] ] ]
	].
]

{ #category : 'propagating' }
WSGraph >> restoreEntropyHeap [
	"If the heap is empty, it selects a random node to continue the execution. This is beacuse if the heap is empty, it means that all nodes that are not collapsed yet have the same entropy"
	
	| nodesArray isCollapsed nodeToAdd |
	nodesArray := self nodes.
	isCollapsed := true.

	[ isCollapsed ] whileTrue: [ 
		nodeToAdd := nodesArray at: (nodesArray size atRandom). 
		isCollapsed := nodeToAdd isCollapsed ].
	
	self entropyHeap add: nodeToAdd
]

{ #category : 'deprecated' }
WSGraph >> runDijkstraFrom: startNode to: endNode [

    | dijkstra dijkstraNodes dijkstraEdges shortestPath |
    dijkstraEdges := OrderedCollection new.
    dijkstraNodes := OrderedCollection new.
    
    dijkstraNodes addAll: (self nodes select: [ :eachNode | 
		eachNode isNotClassNode 
		and: ([eachNode isNotCrossingNode ]) ]).
	
	dijkstraNodes do: [ :eachNode |
	    eachNode outgoingEdges do: [ :eachEdge |
	        | targetNode weight |
	        targetNode := eachEdge target.
	        (dijkstraNodes includes: targetNode) ifTrue: [
	            weight := targetNode isPathNode
	                ifTrue: [ 100 ]
	                ifFalse: [ 1 ].
	            dijkstraEdges add: { eachNode . targetNode . weight } ] ] ].
    
    dijkstra := AIDijkstra new.
    dijkstra nodes: dijkstraNodes.
    dijkstra
        edges: dijkstraEdges
        from: #first
        to: #second
        weight: #third.
    shortestPath := (dijkstra runFrom: startNode to: endNode) asOrderedCollection.

    ^ shortestPath
]

{ #category : 'path optimization' }
WSGraph >> runDijkstraFrom: startNode to: endNode onNodes: dijkstraNodes [

    | dijkstra dijkstraEdges shortestPath |
    dijkstraEdges := OrderedCollection new.

	dijkstraNodes do: [ :eachNode |
	    eachNode outgoingEdges do: [ :eachEdge |
	        | targetNode weight |
	        targetNode := eachEdge target.
	        (dijkstraNodes includes: targetNode) ifTrue: [
	            weight := targetNode isPathNode
	                ifTrue: [ WSConfig dijkstraTraversingPathWeight ]
	                ifFalse: [ 1 ].
	            dijkstraEdges add: { eachNode . targetNode . weight } ] ] ].
    
    dijkstra := AIDijkstra new.
    dijkstra nodes: dijkstraNodes.
    dijkstra
        edges: dijkstraEdges
        from: #first
        to: #second
        weight: #third.
    shortestPath := (dijkstra runFrom: startNode to: endNode) asOrderedCollection.

    ^ shortestPath
]

{ #category : 'deprecated' }
WSGraph >> runDijkstraFrom: startNode to: endNode withExtraNodes: extraNodes [

    | dijkstra dijkstraNodes dijkstraEdges shortestPath |
    dijkstraEdges := OrderedCollection new.
    dijkstraNodes := OrderedCollection new.
    
    dijkstraNodes addAll: extraNodes.
    dijkstraNodes addAll: (self nodes select: [ :eachNode | eachNode tileInWhichCollapsed isEmptyTile ]).
    
    dijkstraNodes do: [ :eachNode |
        eachNode outgoingEdges do: [ :eachEdge |
            | targetNode |
            targetNode := eachEdge target.
            (dijkstraNodes includes: targetNode) ifTrue: [
                dijkstraEdges add: { eachNode . targetNode . 1 } ] ] ].
    
    dijkstra := AIDijkstra new.
    dijkstra nodes: dijkstraNodes.
    dijkstra
        edges: dijkstraEdges
        from: #first
        to: #second
        weight: #third.
    shortestPath := (dijkstra runFrom: startNode to: endNode) asOrderedCollection.

    ^ shortestPath
]

{ #category : 'deprecated' }
WSGraph >> runDijkstraFrom: startNode to: endNode withExtraNodes: extraNodes pathID: pathID [
	"Run dijkstra from startNode to endNode"

    | dijkstra dijkstraNodes dijkstraEdges shortestPath |

	 dijkstraEdges := OrderedCollection new.
    dijkstraNodes := Set new.
	
    dijkstraNodes addAll: extraNodes;
    				   addAll: (self nodes flattened select: [ :eachNode | eachNode isNotClassNode ]).

    dijkstraNodes do: [ :eachNode |
        eachNode outgoingEdges do: [ :eachEdge |
            | targetNode weight shouldSkip |
            targetNode := eachEdge target.
            (dijkstraNodes includes: targetNode) ifTrue: [
				shouldSkip := false.
				(eachNode isPathNode and: [ targetNode isPathNode ]) ifTrue: [
				    (targetNode tileInWhichCollapsed pathIDs anySatisfy: [ :id |
				        id ~= pathID and: [ targetNode tileInWhichCollapsed pathIDs includes: id ] ])
				            ifTrue: [ shouldSkip := true ] ].
				(eachNode isPathNode and: [ targetNode isClassNode ]) ifTrue: [
				    ((targetNode tileInWhichCollapsed edges at: eachEdge oppositeDirection) includes: pathID) 
				            ifFalse: [ shouldSkip := true ] ].
				(eachNode isClassNode and: [ targetNode isPathNode ]) ifTrue: [
    				((eachNode tileInWhichCollapsed edges at: eachEdge direction) includes: pathID)
        ifFalse: [ shouldSkip := true ] ].
					shouldSkip ifFalse: [  
                weight := (targetNode isPathNode and: [
                               (targetNode tileInWhichCollapsed pathIDs includes: pathID) not ])
                              ifTrue: [ 1 ]
                              ifFalse: [ 1 ].
                dijkstraEdges add: { eachNode . targetNode . weight } ] ] ]].

    dijkstra := AIDijkstra new.
    dijkstra nodes: dijkstraNodes.
    dijkstra
        edges: dijkstraEdges
        from: #first
        to: #second
        weight: #third.

    shortestPath := (dijkstra runFrom: startNode to: endNode) asOrderedCollection.

    ^ shortestPath
]

{ #category : 'deprecated' }
WSGraph >> runDijkstraFrom: startNode to: endNode withExtraNodes: extraNodes pathID: pathID zeroNodes: zeroNodes [
    "Run dijkstra from startNode to endNode"
    | dijkstra dijkstraNodes dijkstraEdges shortestPath |
    dijkstraEdges := OrderedCollection new.
    dijkstraNodes := Set new.
	
    dijkstraNodes addAll: extraNodes;
                   addAll: (self nodes flattened select: [ :eachNode | eachNode isNotClassNode ]).
    dijkstraNodes do: [ :eachNode |
        eachNode outgoingEdges do: [ :eachEdge |
            | targetNode weight shouldSkip |
            targetNode := eachEdge target.
            (dijkstraNodes includes: targetNode) ifTrue: [
                shouldSkip := false.
                (eachNode isPathNode and: [ targetNode isPathNode ]) ifTrue: [
                    (eachNode tileInWhichCollapsed pathIDs anySatisfy: [ :id |
                        id ~= pathID and: [ targetNode tileInWhichCollapsed pathIDs includes: id ] ])
                            ifTrue: [ shouldSkip := true ] ].
                (eachNode isPathNode and: [ targetNode isClassNode ]) ifTrue: [
                    ((targetNode tileInWhichCollapsed edges at: eachEdge oppositeDirection) includes: pathID)
                            ifFalse: [ shouldSkip := true ] ].
                shouldSkip ifFalse: [
                    weight := (zeroNodes includes: targetNode)
                        ifTrue: [ 0 ]
                        ifFalse: [
                            (targetNode isPathNode and: [
                                (targetNode tileInWhichCollapsed pathIDs includes: pathID) not ])
                                    ifTrue: [ 1 ]
                                    ifFalse: [ 1 ] ].
                    dijkstraEdges add: { eachNode. targetNode. weight } ] ] ] ].
    dijkstra := AIDijkstra new.
    dijkstra nodes: dijkstraNodes.
    dijkstra
        edges: dijkstraEdges
        from: #first
        to: #second
        weight: #third.
    shortestPath := (dijkstra runFrom: startNode to: endNode) asOrderedCollection.
    ^ shortestPath
]

{ #category : 'collapse' }
WSGraph >> selectNextNodeToCollapse [
	"Returns the cell to collapse"

	^ self entropyHeap removeFirst .

]

{ #category : 'path reification' }
WSGraph >> setPathLengths [
	"Set the lengths for each path"

	self paths do: [ :eachPath |
		eachPath nodes: eachPath nodes asOrderedCollection.
		eachPath computeLength 
	]

]

{ #category : 'path optimization' }
WSGraph >> shouldSkipEdge: eachEdge from: eachNode to: targetNode forPath: pathID [
	"Determine if an edge violates topology constraints for the given pathID"
	| emptyEdgeSymbol |
	emptyEdgeSymbol := WSConfig emptyEdgeSymbol.
	
	"Class -> Path: Controlla se il pathID può USCIRE dalla classe in questa direzione"
	(eachNode isClassNode and: [ targetNode isPathNode ]) ifTrue: [
		| allowedIDs |
		allowedIDs := eachNode tileInWhichCollapsed edges at: eachEdge direction ifAbsent: [ #() ].
		^ ((allowedIDs includes: emptyEdgeSymbol ) or: [ allowedIDs includes: pathID ]) not ].
		
	"Path -> Class: controlla se si può entrare nella classe da quella direzione"
(eachNode isPathNode and: [ targetNode isClassNode ]) ifTrue: [
		| allowedIDs |
		allowedIDs := targetNode tileInWhichCollapsed edges at: eachEdge oppositeDirection ifAbsent: [ #() ].
		^ ((allowedIDs includes: emptyEdgeSymbol) or: [ allowedIDs includes: pathID ]) not ].
		
	"Path -> Path: Evita la sovrapposizione con path estranei"
	(eachNode isPathNode and: [ targetNode isPathNode ]) ifTrue: [
		| targetIDs |
		targetIDs := targetNode tileInWhichCollapsed pathIDs.
		(targetIDs includes: pathID) ifFalse: [ ^ true ] ].
		
	^ false
]

{ #category : 'accessing' }
WSGraph >> structure [

	^ structure
]

{ #category : 'accessing' }
WSGraph >> structure: anObject [

	structure := anObject
]

{ #category : 'path optimization' }
WSGraph >> substitute: oldPath with: optimalPath [
	"Replace a generated path by erasing it with the optimal path created by Dijkstra"

	| pathID sourceClass destClass touchedNodes newFirstNode newLastNode |
	pathID := oldPath pathID.
	sourceClass := oldPath sourceClasses first.
	destClass := oldPath destinationClasses first.
	
	touchedNodes := (self clearPath: oldPath) asSet.

	optimalPath size = 1 ifTrue: [
		| loneNode |
		loneNode := self collapseNode: optimalPath first
						toPathTile: pathID
						between: sourceClass
						and: destClass.
		
		oldPath firstNodes: {loneNode} asOrderedCollection.
		oldPath lastNodes: {loneNode} asOrderedCollection.
		oldPath addNode: loneNode.
		oldPath length: 1.
		
		touchedNodes add: loneNode.
		^ touchedNodes ].

	newFirstNode := self collapseNode: optimalPath first
						toPathTile: pathID
						between: sourceClass
						and: optimalPath second.
	oldPath firstNodes: {newFirstNode} asOrderedCollection.
	oldPath addNode: newFirstNode.

	2 to: optimalPath size - 1 do: [ :i |
		| newNode |
		newNode := self collapseNode: (optimalPath at: i)
						toPathTile: pathID
						between: (optimalPath at: i - 1)
						and: (optimalPath at: i + 1).
		oldPath addNode: newNode ].

	newLastNode := self collapseNode: optimalPath last
						toPathTile: pathID
						between: (optimalPath at: optimalPath size - 1)
						and: destClass.
	oldPath lastNodes: {newLastNode} asOrderedCollection.
	oldPath addNode: newLastNode.
	
	oldPath length: oldPath nodes size.
	
	touchedNodes addAll: optimalPath.
	
	^ touchedNodes
]

{ #category : 'deprecated' }
WSGraph >> substituteIfShorter: optimalPath for: generatedPath updatingExits: aBoolean [

	optimalPath size < generatedPath length ifFalse: [ ^ self ].
	
	generatedPath touchedClasses size = 2 
		ifTrue: [ self substitute: generatedPath with: optimalPath. ]
		ifFalse: [ self substituteMergedPath: generatedPath with: optimalPath ]
	

	"aBoolean ifTrue: [ self updateExitTilesFor: generatedPath ]"
]

{ #category : 'path optimization' }
WSGraph >> substituteIfShorter: optimalPath with: generatedPath [
	
	| touchedNodes |
	
	optimalPath size < generatedPath length ifFalse: [ ^ { } ].
	touchedNodes := 
		generatedPath touchedClasses size = 2 
			ifTrue: [ self substitute: generatedPath with: optimalPath. ]
			ifFalse: [ self substituteMergedPath: generatedPath with: optimalPath ].
	
	self updateExitTilesFor: generatedPath.
	generatedPath efficiency: 1.
	^ touchedNodes 
]

{ #category : 'deprecated' }
WSGraph >> substituteMergedPath2: oldPath with: optimalPath [
    "Replace a merged path by recollapsing each node based on its actual neighbors in optimalPath"
    | pathID optimalSet |
    pathID := oldPath pathID.
    self clearPath: oldPath.
    
    optimalSet := optimalPath asSet.
    
    optimalPath do: [ :eachNode |
        | neighborsDir dict |
		  dict := Dictionary new.
			eachNode isPathNode ifTrue: [ 
				eachNode tileInWhichCollapsed edges keysAndValuesDo: [ :key :value |
					(value includes: #'00') ifFalse: [ dict at: key put: value first ]
				]
			].
        neighborsDir := eachNode outgoingEdges 
    			select: [ :eachEdge |
 					(optimalSet includes: eachEdge target) 
					or: [ 
						(eachEdge target isClassNode and: [ oldPath touchedClasses includes: eachEdge target ])
						" and: [ (eachEdge target tileInWhichCollapsed edges at: eachEdge oppositeDirection) includes: pathID ]" ] ]
    			thenCollect: [ :eachEdge | eachEdge direction ].
		
		neighborsDir do: [ :eachDir | dict at: eachDir put: pathID ].
		eachNode collapseTo: (self topology tileset tileForDirections: dict)
	].
 
    

]

{ #category : 'path optimization' }
WSGraph >> substituteMergedPath: oldPath with: optimalPath [
	"Replace a merged path by recollapsing each node based on its actual neighbors in optimalPath"
	
	| pathID optimalSet touchedNodes chosenClassConnections |
	pathID := oldPath pathID.
	
	touchedNodes := (self clearPath: oldPath) asSet.
	optimalSet := optimalPath asSet.
	
	chosenClassConnections := self 
		calculateBestConnectionsFrom: optimalSet 
		toClasses: oldPath touchedClasses.
	
	optimalPath do: [ :eachNode |
		| neighborsDir dict |
		dict := Dictionary new.
		
		eachNode tileInWhichCollapsed edges keysAndValuesDo: [ :key :value |
			value isEmpty 
				ifTrue: [ dict at: key put: WSConfig emptyEdgeSymbol ]
				ifFalse: [ dict at: key put: value first ] ].
				
		neighborsDir := eachNode outgoingEdges 
			select: [ :eachEdge |
				(optimalSet includes: eachEdge target) 
				or: [ 
					chosenClassConnections includes: (eachNode -> eachEdge target)
				] 
			]
			thenCollect: [ :eachEdge | eachEdge direction ].
		
		neighborsDir do: [ :eachDir | dict at: eachDir put: pathID ].
		eachNode collapseTo: (self topology tileset tileForDirections: dict).
		
		touchedNodes add: eachNode.
	].

	oldPath nodes: optimalPath asOrderedCollection.
	oldPath length: optimalPath size.

	self assignSourceAndDestinationFor: oldPath.
	self assignFirstAndLastNodesFor: oldPath.

	^ touchedNodes
]

{ #category : 'accessing' }
WSGraph >> topology [

	^ topology
]

{ #category : 'accessing' }
WSGraph >> topology: anObject [

	topology := anObject
]

{ #category : 'deprecated' }
WSGraph >> updateExitForFootprint: aFootprint adjacentTo: aPathNode withPathID: aPathID [
    "Remove pathID from all exits of the footprint, then reassign it to the node adjacent to aPathNode"
    
    | emptySymbol exitEdge exitEdgeSymbols |
    emptySymbol := WSConfig emptyEdgeSymbol.
    
    "Remove pathID from all exits of all nodes in the footprint"
    aFootprint nodes do: [ :aNode |
         aNode tileInWhichCollapsed edges do: [ :edgeSymbols |
        		(edgeSymbols includes: aPathID) ifTrue: [
            		edgeSymbols remove: aPathID.
            		edgeSymbols add: emptySymbol ] ] ].
    
    "Find which footprint node is adjacent to aPathNode"
	 exitEdge := ((aFootprint borderNodes: self topology) 
		 flatCollect: [ :eachNode | eachNode outgoingEdges ])
	    detect: [ :eachEdge | eachEdge target = aPathNode ].
    
    "Assign pathID to that exit"
    exitEdgeSymbols := (exitEdge source tileInWhichCollapsed edges) at: (exitEdge direction).
    exitEdgeSymbols 
		remove: emptySymbol ifAbsent: [];
      add: aPathID.
]

{ #category : 'path optimization' }
WSGraph >> updateExitTilesFor: generatedPath [
    "Understand which footprint is adjacent to which path node, then update the exits"

    | pathID |
    pathID := generatedPath pathID.

	 generatedPath touchedClasses do: [ :eachClassNode | 
		| footprint |
		footprint := eachClassNode footPrint.
		(footprint borderNodes: self topology) do: [ :eachBorderNode |
			| tile dir |
			tile := eachBorderNode tileInWhichCollapsed.
			dir := eachBorderNode outgoingEdges 
				select: [ :eachEdge | 
					(eachEdge target tileInWhichCollapsed edges at: eachEdge oppositeDirection) includes: pathID ]
				thenCollect: [ :eachEdge | eachEdge direction ].
			
			tile edges keysAndValuesDo: [ :eachDir : eachValue | 
				(dir includes: eachDir) 
					ifTrue: [ tile edges at: eachDir put: (OrderedCollection with: pathID)  ]
					ifFalse: [ tile edges at: eachDir put: (OrderedCollection with: WSConfig emptyEdgeSymbol) ]
			].
		]
	 ].	
]

{ #category : 'propagating' }
WSGraph >> updateMinEntropyHeap: aNodesArray [
	"Update the min heap by updating the position of each node that has been changed during a propagation wave"

	self entropyHeap addAll: 
		(aNodesArray collect: [ 
			:eachNode |
				self entropyHeap remove: eachNode ifAbsent: [ ].
				eachNode 
			]
		)
]
