"
The graph structure on which the WFC algorithm is executed
"
Class {
	#name : 'WSGraph',
	#superclass : 'WSObject',
	#instVars : [
		'nodes',
		'minEntropyHeap',
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

{ #category : 'creation' }
WSGraph class >> createClassNodesFrom: collapsedNodes [

	| dict |
	dict := Dictionary new.
	
	collapsedNodes do: [ :eachNode | 
		dict at: (eachNode tileInWhichCollapsed wsClass) put: eachNode 
	].
	
	^ dict

]

{ #category : 'fuel support' }
WSGraph class >> fuelIgnoredInstanceVariableNames [
    ^ #('topology')
]

{ #category : 'instance creation' }
WSGraph class >> newWithStructure: aStructure andCollapsedNodes: collapsedNodes andTopology: aTopology [
	
	| allNodes |
	allNodes := aStructure getFlattenedNodes.

	^ self new
		structure: aStructure;
		nodes: allNodes;
		topology: aTopology;
		paths: Dictionary new;
		numberOfNodes: allNodes size;
		numberOfCollapsedNodes: 0;
		minEntropyHeap: (Heap new addAll: collapsedNodes; yourself) 
]

{ #category : 'collapse' }
WSGraph >> addOneToCollapsedNodes [

	self numberOfCollapsedNodes: (self numberOfCollapsedNodes + 1)
]

{ #category : 'pathReification' }
WSGraph >> adjacentPathNodeIn: aPath for: aNode [
    "Returns the node in aPath adjacent to aNode, or nil if the path is a single point"
    | idx pathNodes |
    pathNodes := aPath nodes asOrderedCollection .
    pathNodes size < 2 ifTrue: [ ^ nil ]. "Gestione caso nodo singolo"
    
    idx := pathNodes indexOf: aNode.
    idx = 1 ifTrue: [ ^ pathNodes second ].
    idx = pathNodes size ifTrue: [ ^ pathNodes at: pathNodes size - 1 ].
    ^ pathNodes at: idx + 1

"adjacentPathNodeIn: aPath for: aNode
    ""Returns the node in aPath adjacent to aNode (its neighbour within the path)""
    | idx |
    idx := aPath nodes indexOf: aNode.
    idx = 1 ifTrue: [ ^ aPath nodes second ].
    idx = aPath nodes size ifTrue: [ ^ aPath nodes at: aPath nodes size - 1 ].
    ^ aPath nodes at: idx + 1"
]

{ #category : 'collapse' }
WSGraph >> allNodesCollapsed [
	"Returns true if all nodes in the graph have collapsed, otherwise false"

	^ self numberOfNodes = self numberOfCollapsedNodes
]

{ #category : 'pathReification' }
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

{ #category : '2DGrid' }
WSGraph >> atRow: row atColumn: column [
	
	^ self structure atRow: row atColumn: column 
]

{ #category : 'pathOptimization' }
WSGraph >> borderNodeOf: aFootprint adjacentTo: aPathNode [
    "Return the border node of aFootprint that is adjacent to aPathNode"
    
    ^ (aFootprint borderNodes: self topology)
        detect: [ :aNode | aNode outgoingEdges anySatisfy: [ :eachEdge | eachEdge target = aPathNode ] ]
]

{ #category : 'pathOptimization' }
WSGraph >> clearPath: aPath [
	"Clear a path replacing each tile with the empty tile"

	| emptyTile touchedNodes |
	touchedNodes := OrderedCollection new.
	emptyTile := self topology createEmptyTile.

	aPath nodes do: [ :eachNode |
		touchedNodes add: eachNode.
		eachNode collapseTo: emptyTile.
	].

	aPath nodes: OrderedCollection new.
	aPath length: Float infinity.
	aPath firstNode: nil.
	aPath lastNode: nil.
	
	^ touchedNodes 
	
]

{ #category : 'pathOptimization' }
WSGraph >> clearPathWithID: anID [

	^ self clearPath: (self paths at: anID)
]

{ #category : 'pathOptimization' }
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

{ #category : 'pathReification' }
WSGraph >> createPaths [
    "Create the instances of wsPaths"
    
    | pathIDs visitedNodesPerPath |
    pathIDs := self topology allPathIDs .
    
    visitedNodesPerPath := Dictionary new.
    pathIDs do: [ :pathID | 
        self paths at: pathID put: OrderedCollection new.
        visitedNodesPerPath at: pathID put: Set new ].
    
    self topology classFootprint keysAndValuesDo: [ :eachClass :eachFootprint |
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
                    newPath firstNode: eachEdge target.
                    newPath addTouchedClass: eachClassNode.
                    
                    visited := Set with: eachClassNode.
                    self followPath: newPath
                        from: eachEdge
                        visited: visited
                        pathID: pathID.
                   
                    (visitedNodesPerPath at: pathID) addAll: newPath nodes.
                    
                    self assignSourceAndDestination: newPath.
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
					((eachNode ~= eachPath firstNode) and: [ eachNode isNotCrossingNode ]) ifTrue: [ 
						eachNode collapseTo: emptyTile 
					]
				].
				eachPath nodes: (OrderedCollection with: eachPath firstNode)
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

{ #category : 'pathOptimization' }
WSGraph >> findOptimalPathWithID: pathID [
	"Find optimal path between two classes. Does NOT change the exit for each class"
	
    | pathObject shortestPath |

    pathObject := self paths at: pathID.

    shortestPath := self 
        runDijkstraFrom: pathObject firstNode 
        to: pathObject lastNode 
        withExtraNodes: #() 
        pathID: pathID.

    ^ shortestPath
]

{ #category : 'pathOptimization' }
WSGraph >> findOptimalPathWithID: pathID andClasses: classes [
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

{ #category : 'pathReification' }
WSGraph >> followPath: aPath from: anEdge visited: visited pathID: aPathID [
    | node tile reverseDir |
    node := anEdge target.
    (visited includes: node) ifTrue: [ ^ self ].
    visited add: node.
    
    tile := node tileInWhichCollapsed.
    
    tile isClassTile ifTrue: [
        aPath lastNode: anEdge source.
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

{ #category : 'pathOptimization' }
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

{ #category : '2DGrid' }
WSGraph >> isInBoundsRow: row column: col [

	^ self structure isInBoundsRow: row column: col 
]

{ #category : 'pathReification' }
WSGraph >> mergePath: pathA withPath: pathB usingConnection: connectionNodes pathID: pathID [
    "Merge two paths into one, collapsing the connection nodes as path tiles.
     connectionNodes: first and last are already path tiles, middle ones are empty tiles."
    | mergedPath connectionMiddle adjA adjB |
    
    mergedPath := WSPath withID: pathID.
    
	"Collassa nodi di mezzo"
    connectionMiddle := connectionNodes copyFrom: 2 to: connectionNodes size - 1.
    connectionMiddle doWithIndex: [ :aNode :i |
        | prevNode nextNode |
        prevNode := connectionNodes at: i.      
        nextNode := connectionNodes at: i + 2.
        self collapseNode: aNode
            toPathTile: pathID
            between: prevNode
            and: nextNode ].
    
    "Ricollassa il primo nodo"
    connectionNodes size > 1 ifTrue: [
        | firstConn secondConn lastConn secondLastConn |
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
    
    pathA nodes do: [ :node | mergedPath addNode: node ].
    connectionMiddle do: [ :node | mergedPath addNode: node].
    pathB nodes do: [ :node | mergedPath addNode: node ].
    
    mergedPath firstNode: pathA firstNode; lastNode: pathB lastNode.
    
    pathA sourceClasses do: [ :c | mergedPath addSourceClass: c ].
    pathB sourceClasses do: [ :c | mergedPath addSourceClass: c ].
    pathA destinationClasses do: [ :c | mergedPath addDestinationClass: c ].
    pathB destinationClasses do: [ :c | mergedPath addDestinationClass: c ].
    self reassignSourceDestination: mergedPath.
    
    ^ mergedPath
]

{ #category : 'pathReification' }
WSGraph >> mergePathsWithSameID [
	"If two paths with the same ID are not connected, merge them"

    self paths keysAndValuesDo: [ :pathID :collectionOfPaths |
        [ collectionOfPaths size > 1 ] whileTrue: [
            | bestPair bestDistance bestShortestPath dijkstraNodes |
            bestDistance := Float infinity.
            bestPair := nil.
            bestShortestPath := nil.

				dijkstraNodes := OrderedCollection new.
    
			    dijkstraNodes addAll: (self nodes select: [ :eachNode | 
					eachNode isNotClassNode 
					and: ([eachNode isNotCrossingNode ]) ]).

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
                collectionOfPaths remove: pathA; remove: pathB; add: mergedPath ] ] ]
]

{ #category : 'accessing' }
WSGraph >> minEntropyHeap [

	^ minEntropyHeap
]

{ #category : 'accessing' }
WSGraph >> minEntropyHeap: anObject [

	minEntropyHeap := anObject
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

{ #category : 'pathOptimization' }
WSGraph >> optimizeAllPathsAllowingExitModifications: aBoolean [
	"Optimize all the paths, decide if you allow exit changing"

	self optimizePathsWithPathIDs: (self topology allPathIDs) allowExitsModification: aBoolean 
]

{ #category : 'pathOptimization' }
WSGraph >> optimizePathsWithExitModification: pathIDs [
	"Optimize all the paths which pathID is in pathIDs"
	
	| touchedNodes |
	touchedNodes := Set new.

	pathIDs do: [ :eachPathID |
		| generatedPath optimalPath classes |
		
		generatedPath := self paths at: eachPathID.
		
		classes := self topology allPathIDs keyAtValue: eachPathID.
		optimalPath :=  self findOptimalPathWithID: eachPathID andClasses: classes.
		touchedNodes addAll: generatedPath nodes; addAll: optimalPath.
		
		generatedPath sourceClasses: (((self topology classFootprint at: classes key) borderNodes: self topology) first).
		generatedPath destinationClasses: (((self topology classFootprint at: classes value) borderNodes: self topology) first).
		self substituteIfShorter: optimalPath for: generatedPath updatingExits: true.	
	]. 

	^ touchedNodes
]

{ #category : 'pathOptimization' }
WSGraph >> optimizePathsWithPathIDs: pathIDs allowExitsModification: aBoolean [
	"Optimize all the paths which pathID is in pathIDs"

	aBoolean 
		ifTrue: [ ^ self optimizePathsWithExitModification: pathIDs ] 
		ifFalse: [ ^ self optimizePathsWithoutExitModification: pathIDs ] 
]

{ #category : 'pathOptimization' }
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

{ #category : 'pathReification' }
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

{ #category : 'propagating' }
WSGraph >> restoreMinEntropyHeap [
	"If the entropy is empty, it select a random node to continue the execution"
	
	| nodesArray isCollapsed nodeToAdd |
	nodesArray := self nodes.
	isCollapsed := true.
	
	[ isCollapsed ] whileTrue: [ 
		nodeToAdd := nodesArray at: (nodesArray size atRandom). 
		isCollapsed := nodeToAdd isCollapsed ].
	
	self minEntropyHeap add: nodeToAdd
	
	
	
]

{ #category : 'pathOptimization' }
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

{ #category : 'pathOptimization' }
WSGraph >> runDijkstraFrom: startNode to: endNode  onNodes: dijkstraNodes [

    | dijkstra dijkstraEdges shortestPath |
    dijkstraEdges := OrderedCollection new.

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

{ #category : 'pathOptimization' }
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

{ #category : 'pathOptimization' }
WSGraph >> runDijkstraFrom: startNode to: endNode withExtraNodes: extraNodes pathID: pathID [
	"Run dijkstra from startNode to endNode"

    | dijkstra dijkstraNodes dijkstraEdges shortestPath |

	 dijkstraEdges := OrderedCollection new.
    dijkstraNodes := OrderedCollection new.
	
    dijkstraNodes addAll: extraNodes;
    				   addAll: (self paths at: pathID) nodes;
    				   addAll: (self nodes flattened select: [ :eachNode | eachNode tileInWhichCollapsed isEmptyTile ]).

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

{ #category : 'collapse' }
WSGraph >> selectNextNodeToCollapse [
	"Returns the cell to collapse"
	
	^ self minEntropyHeap removeFirst .
]

{ #category : 'pathReification' }
WSGraph >> setPathLengths [

	self paths keysAndValuesDo: [ :key :allPaths |
		allPaths do: [ :eachPath | 
			eachPath nodes: eachPath nodes asOrderedCollection.
			eachPath computeLength 
		]
	]
]

{ #category : 'accessing' }
WSGraph >> structure [

	^ structure
]

{ #category : 'accessing' }
WSGraph >> structure: anObject [

	structure := anObject
]

{ #category : 'pathOptimization' }
WSGraph >> substitute: oldPath with: optimalPath [
	"Replace a generated path by erasing it with the optimal path created by Dijkstra"

    | newFirstNode newLastNode pathID |
    pathID := oldPath pathID.
    self clearPath: oldPath.

	optimalPath size = 1 ifTrue: [
        | loneNode |
        loneNode := self collapseNode: optimalPath first
                        toPathTile: pathID
                        between: (self getAdjacentClassForNode: optimalPath first)
                        and: (self getAdjacentClassForNode: optimalPath first).
        oldPath firstNode: loneNode.
        oldPath lastNode: loneNode.
        oldPath addNode: loneNode.
        oldPath length: 1.
        ^ self ].

    newFirstNode := (self collapseNode: optimalPath first
        toPathTile: pathID
        between: (self getAdjacentClassForNode: optimalPath first)
        and: optimalPath second).
	oldPath firstNode: newFirstNode.
	oldPath addNode: newFirstNode.

    2 to: optimalPath size - 1 do: [ :i |
		| newNode |
       newNode := self collapseNode: (optimalPath at: i)
           toPathTile: pathID
           between: (optimalPath at: i - 1)
           and: (optimalPath at: i + 1).
		oldPath addNode: newNode
		
	 ].

    newLastNode := (self collapseNode: optimalPath last
        toPathTile: pathID
        between: (optimalPath at: optimalPath size - 1)
        and: (self getAdjacentClassForNode: optimalPath last)).
	oldPath lastNode: newLastNode.
	oldPath addNode: newLastNode.
	
	oldPath length: oldPath nodes size
]

{ #category : 'pathOptimization' }
WSGraph >> substituteIfShorter: optimalPath for: generatedPath updatingExits: aBoolean [

	optimalPath size < generatedPath length ifFalse: [ ^ self ].

	self substitute: generatedPath with: optimalPath.

	aBoolean ifTrue: [ self updateExitTilesFor: generatedPath ]
]

{ #category : 'accessing' }
WSGraph >> topology [

	^ topology
]

{ #category : 'accessing' }
WSGraph >> topology: anObject [

	topology := anObject
]

{ #category : 'pathOptimization' }
WSGraph >> updateExitForFootprint: aFootprint adjacentTo: aPathNode withPathID: aPathID [
    "Remove pathID from all exits of the footprint, then reassign it to the node adjacent to aPathNode"
    
    | emptySymbol exitEdge exitEdgeSymbols |
    emptySymbol := self topology class emptyEdgeSymbol.
    
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

{ #category : 'pathOptimization' }
WSGraph >> updateExitTilesFor: generatedPath [
    "Understand which footprint is adjacent to which path node, then update the exits"

    | pathID footprint1 footprint2 firstAdjacent lastAdjacent |
    pathID := generatedPath pathID.
    footprint1 := generatedPath sourceClasses footPrint.
    footprint2 := generatedPath destinationClasses footPrint.
    
    firstAdjacent := ((footprint1 borderNodes: self topology) 
        anySatisfy: [ :aNode | aNode outgoingEdges anySatisfy: [ :e | e target = generatedPath firstNode ] ])
            ifTrue: [ footprint1 ]
            ifFalse: [ footprint2 ].
    lastAdjacent := firstAdjacent = footprint1 ifTrue: [ footprint2 ] ifFalse: [ footprint1 ].
    
    generatedPath sourceClasses: (self borderNodeOf: firstAdjacent adjacentTo: generatedPath firstNode).
    generatedPath destinationClasses: (self borderNodeOf: lastAdjacent adjacentTo: generatedPath lastNode).
    
    self updateExitForFootprint: firstAdjacent adjacentTo: generatedPath firstNode withPathID: pathID.
    self updateExitForFootprint: lastAdjacent adjacentTo: generatedPath lastNode withPathID: pathID.
]

{ #category : 'propagating' }
WSGraph >> updateMinEntropyHeap: aNodesArray [
	"Update the min heap by updating the position of each node that has been changed during a propagation wave"

	self minEntropyHeap addAll: 
		(aNodesArray collect: [ 
			:eachNode |
				self minEntropyHeap remove: eachNode ifAbsent: [ ].
				eachNode 
			]
		)
]
