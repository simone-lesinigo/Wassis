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
		'classesNodes',
		'numberOfNodes',
		'numberOfCollapsedNodes',
		'topology'
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
WSGraph class >> newWithNodes: nodes andCollapsedNodes: collapsedNodes andTopology: aTopology [

	^ self new
		nodes: nodes;
		classesNodes: (self createClassNodesFrom: collapsedNodes);
		topology: aTopology;
		paths: Dictionary new;
		numberOfNodes: nodes flattened size;
		numberOfCollapsedNodes: 0;
		minEntropyHeap: (Heap new addAll: collapsedNodes; yourself) 
]

{ #category : 'collapse' }
WSGraph >> addOneToCollapsedNodes [

	self numberOfCollapsedNodes: (self numberOfCollapsedNodes + 1)
]

{ #category : 'collapse' }
WSGraph >> allNodesCollapsed [
	"Returns true if all nodes in the graph have collapsed, otherwise false"

	^ self numberOfNodes = self numberOfCollapsedNodes
]

{ #category : 'as yet unclassified' }
WSGraph >> assignPathsToNodes [
	"At each node assign its path"
	
	self paths do: [ :eachPath | 
		eachPath nodes do: [ :eachNode |
			eachNode path: eachPath 
		]
	].
]

{ #category : 'accessing' }
WSGraph >> classesNodes [

	^ classesNodes
]

{ #category : 'accessing' }
WSGraph >> classesNodes: anObject [

	classesNodes := anObject
]

{ #category : 'optimization' }
WSGraph >> clearPath: aPath [
	"Clear a path replacing each tile with the empty tile"

	| emptyTile |
	emptyTile := self topology createEmptyTile.

	aPath nodes do: [ :eachNode |
		eachNode collapseTo: emptyTile.
	].

	aPath nodes: OrderedCollection new.
	aPath length: nil.
	aPath firstNode: nil.
	aPath lastNode: nil
]

{ #category : 'optimization' }
WSGraph >> collapseNode: aNode toPathTile: pathID between: prevNode and: nextNode [
	"Collapse a node to the right path tile"

    | dir |
    dir := aNode outgoingEdges
        select: [ :eachEdge | eachEdge target = prevNode or: [ eachEdge target = nextNode ] ]
        thenCollect: [ :eachEdge | eachEdge direction ].

    ^ aNode collapseTo: (self topology tileset tileForDirections: dir pathID: pathID)
]

{ #category : 'reification' }
WSGraph >> createPathFrom: anEdge [
	"Given an edge, it creates the WFCpath from that edge"

	| node targetTile reverseEdgeDir |
	node := anEdge target.
	targetTile:= node tileInWhichCollapsed.
	reverseEdgeDir := anEdge reverseEdge direction.
	
	targetTile isClassTile ifTrue: [ 
		| path |
		path := (self paths at: (anEdge source tileInWhichCollapsed pathID)).
		path lastNode: anEdge source; class2: anEdge target
	].
	
	targetTile isPathTile ifTrue: [ 
		| path |
		path := (self paths at: (targetTile pathID)).
		
		anEdge source isClassNode ifTrue: [
            path firstNode: node; class1: anEdge source ].

		path addNode: node.
	
		targetTile edges keysAndValuesDo: [ :aKey :aValue | 
			((aValue anySatisfy: [ :each | each = targetTile pathID ]) and: [ aKey ~= reverseEdgeDir ]) ifTrue:
				[node outgoingEdges do: [ :eachEdge | (eachEdge direction = aKey) ifTrue:
					[ self createPathFrom: eachEdge ] ]]
		]
	]
]

{ #category : 'reification' }
WSGraph >> createPaths [
	"For each class node it creates the WFCPath"
	
	| pathIDs |
	pathIDs := self topology swSystem classesPathIDs.

	pathIDs do: [ :pathID | self paths at: pathID put: (WSPath withID:pathID) ].
	
	self classesNodes do: [ :eachClassNode |
		| tileEdges directionsToCheck |
		tileEdges := eachClassNode tileInWhichCollapsed edges.
		
		directionsToCheck := tileEdges keys select: [ :key |
            (tileEdges at: key) anySatisfy: [ :each | pathIDs includes: each ] ].

		eachClassNode outgoingEdges do: [ :eachEdge | 
			(directionsToCheck includes: eachEdge direction) ifTrue: [
				self createPathFrom: eachEdge
			]
		]
	]
]

{ #category : 'reification' }
WSGraph >> destroyLoops [
	
	| nodesArray emptyTile |
	emptyTile := self topology createEmptyTile.
	nodesArray := self nodes flattened.
	nodesArray do: [ :eachNode | 
		| tile |
		tile := eachNode tileInWhichCollapsed.
		(tile isPathTile) ifTrue: [ 
			((self paths at: (tile pathID)) includes: eachNode) ifFalse: [ 
				eachNode collapseTo: emptyTile 	
			]
		]]
	
]

{ #category : 'optimization' }
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

{ #category : 'optimization' }
WSGraph >> findOptimalPathWithID: pathID andClasses: classes [
	"Find optimal path between two classes. May change the exit for each class"

    | class1node class2node shortestPath |
    class1node := self classesNodes at: classes key.
    class2node := self classesNodes at: classes value.

    shortestPath := self
        runDijkstraFrom: class1node
        to: class2node
        withExtraNodes: { class1node . class2node }
        pathID: pathID.

    shortestPath removeFirst.
    shortestPath removeLast.

    ^ shortestPath
]

{ #category : 'optimization' }
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

{ #category : 'optimization' }
WSGraph >> optimizeAllPathsAllowingExitModifications: aBoolean [
	"Optimize all the paths, decide if you allow exit changing"

	self optimizePathsWithPathIDs: (self topology allPathIDs) allowExitsModification: aBoolean 
]

{ #category : 'optimization' }
WSGraph >> optimizePathsWithExitModification: pathIDs [
	"Optimize all the paths which pathID is in pathIDs"

	pathIDs keysAndValuesDo: [ :classes :eachPathID |
		| generatedPath optimalPath |
		
		generatedPath := self paths at: eachPathID.
		optimalPath :=  self findOptimalPathWithID: eachPathID andClasses: classes.
		
		self substituteIfShorter: optimalPath for: generatedPath updatingExits: true.
		
	]
]

{ #category : 'optimization' }
WSGraph >> optimizePathsWithPathIDs: pathIDs allowExitsModification: aBoolean [
	"Optimize all the paths which pathID is in pathIDs"

	aBoolean 
		ifTrue: [ self optimizePathsWithExitModification: pathIDs ] 
		ifFalse: [ self optimizePathsWithoutExitModification: pathIDs ]. 
]

{ #category : 'optimization' }
WSGraph >> optimizePathsWithoutExitModification: pathIDs [
	"Optimize all the paths which pathID is in pathIDs"

	pathIDs do: [ :eachPathID | 
		| generatedPath optimalPath |
		generatedPath := (self paths at: eachPathID).
		optimalPath := self findOptimalPathWithID: eachPathID.
		
		self substituteIfShorter: optimalPath for: generatedPath updatingExits: false.
		
	 ]
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

{ #category : 'propagating' }
WSGraph >> restoreMinEntropyHeap [
	"If the entropy is empty, it select a random node to continue the execution"
	
	| nodesArray isCollapsed nodeToAdd |
	nodesArray := self nodes flattened.
	isCollapsed := true.
	
	[ isCollapsed ] whileTrue: [ 
		nodeToAdd := nodesArray at: (nodesArray size atRandom). 
		isCollapsed := nodeToAdd isCollapsed ].
	
	self minEntropyHeap add: nodeToAdd
	
	
	
]

{ #category : 'optimization' }
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

{ #category : 'initialization' }
WSGraph >> setPathLengths [

	self paths keysAndValuesDo: [ :key :value |
		
		self paths at: key put: value asOrderedCollection.
		(self paths at: key) computeLength
	]
]

{ #category : 'optimization' }
WSGraph >> substitute: oldPath with: optimalPath [
	"Replace a generated path by erasing it with the optimal path created by Dijkstra"

    | newFirstNode newLastNode pathID |
    pathID := oldPath pathID.
    self clearPath: oldPath.

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

{ #category : 'optimization' }
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

{ #category : 'optimization' }
WSGraph >> updateExitFor: aNode withPathID: aPathID [
	"Given a node, it reorganize the class exits. This method is called only when the allowExitModification is set to true"
	
	| edge classTile targetEdgeSymbols emptySymbol|
	
	emptySymbol := self topology class emptyEdgeSymbol .
	edge := aNode outgoingEdges detect: [ :eachEdge | (eachEdge target isClassNode) and: [ 
			eachEdge target tileInWhichCollapsed edges anySatisfy: [ :each | each includes: aPathID ] ] ].
	
	classTile := edge target tileInWhichCollapsed.
	
	classTile edges do: [ :each |
   		each remove: aPathID ifAbsent: [].
      each isEmpty ifTrue: [ each add: emptySymbol ] ].
	
	 targetEdgeSymbols := classTile edges at: edge reverseEdge direction.
    targetEdgeSymbols remove: emptySymbol ifAbsent: [].
    targetEdgeSymbols add: aPathID.
]

{ #category : 'optimization' }
WSGraph >> updateExitTilesFor: generatedPath [
	
	| pathID |
	
	pathID := generatedPath pathID.
	self updateExitFor: generatedPath firstNode withPathID: pathID.
	self updateExitFor: generatedPath lastNode withPathID: pathID.
	
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
