"
Superclasses of all the topologies that relies on a matrix to create the graph
"
Class {
	#name : 'WS2DGridTopology',
	#superclass : 'WSTopology',
	#instVars : [
		'emptyMatrixCheckpoint',
		'nRows',
		'nColumns',
		'layoutMatrix',
		'classFootprint'
	],
	#category : 'Wassis-Topology',
	#package : 'Wassis',
	#tag : 'Topology'
}

{ #category : 'instance creation' }
WS2DGridTopology class >> createOppositeDirections [ 
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
WS2DGridTopology class >> safetyMooreRadius [
	"Levels at which the moore neighbours of a class must be empty in the placement"
	
	^ WS2DGridConfig gridSafetyMooreRadius
]

{ #category : 'instance creation' }
WS2DGridTopology class >> withGrid: aPoint [
	
	^ self new 
		nRows: aPoint x;
		nColumns: aPoint y;
		oppositeDirections: self createOppositeDirections;
		tileset: WSTileset new
]

{ #category : 'collapse' }
WS2DGridTopology >> assignNodesToClassesIn: aGrid [
    "For each class select the node in which it will be placed"
	
    self createClassesPlacingOrder do: [ :eachClass |
        | footprint |
        footprint := self buildFootprintFor: eachClass in: aGrid.
        self collapseFootprintNodes: footprint.
        self classFootprint at: eachClass put: footprint ]
]

{ #category : 'collapse' }
WS2DGridTopology >> buildFootprintFor: aClass in: aGrid [
	"Build the footprint for a class, return the footprint"

    | sideLength originNode footprintNodes |
    sideLength := self footprintSizeFor: aClass.
    originNode := self pickNodeForClass: aClass footprintSize: sideLength in: aGrid.
    footprintNodes := aGrid collectFootprintFrom: originNode size: sideLength.

    ^ WSFootprint new
        wsClass: aClass;
        nodes: footprintNodes;
        originNode: originNode;
        sideLength: sideLength;
        yourself
]

{ #category : 'accessing' }
WS2DGridTopology >> classFootprint [

	^ classFootprint
]

{ #category : 'accessing' }
WS2DGridTopology >> classFootprint: anObject [

	classFootprint := anObject
]

{ #category : 'collapse' }
WS2DGridTopology >> collapseFootprintNodes: aFootprint [
	"Collapse all nodes in the footprint"

    aFootprint nodes do: [ :eachNode |
        eachNode
            isCollapsed: true;
            footPrint: aFootprint ]
]

{ #category : 'collapse' }
WS2DGridTopology >> collapseNodesToClassesIn: aGrid [
    "Collapse some nodes to classes and returns them"
    
    | result |
    result := OrderedCollection new.
    self assignNodesToClassesIn: aGrid.

    self classFootprint keysAndValuesDo: [ :eachClass :eachFootprint |
        | nodesToTile |
        nodesToTile := self createClassTiles: eachClass forFootprint: eachFootprint.
		  
        nodesToTile keysAndValuesDo: [ :eachNode :eachTile |
            result add: (eachNode collapseTo: eachTile) ].
	 ].

	 self classFootprint keysAndValuesDo: [ :eachClass :eachFootprint | 
		   self seedPathTargetsFor: eachClass footprint: eachFootprint
	 ].

    ^ result
]

{ #category : 'deprecated' }
WS2DGridTopology >> createAllPathTiles2 [
	"Create all the necessary path tiles for all entities and returns them"

	| pathTiles |
	
	pathTiles := OrderedCollection new.
	
	self swSystem allPathIDs do: [ :pathID |
			pathTiles addAll: (self createPathTilesWithID: pathID) ].

	^ pathTiles 
]

{ #category : 'tileset' }
WS2DGridTopology >> createClassTiles: aClass forFootprint: aFootprint [

	^ self subclassResponsibility 
]

{ #category : 'collapse' }
WS2DGridTopology >> createClassesPlacingOrder [
	"Create the order in which the class will be placed"
	
	 ^ WSConfig classPlacingOrder orderForSwSystem: self swSystem
]

{ #category : 'matrix' }
WS2DGridTopology >> createEdgesIn: aGrid [

	^ self subclassResponsibility
]

{ #category : 'matrix' }
WS2DGridTopology >> createEmptyMatrix [
	"Creates the nodes and save them in the matrix. All the nodes have the same entropy and contain all the possibile tiles from the tileset"
	
	| grid mockNode |
    mockNode := self createMockNode.
    grid := WSGrid2D withRows: self nRows andColumns: self nColumns.
    
    1 to: self nRows do: [ :i |
        1 to: self nColumns do: [ :j |
            | node |
            node := WSNode new
                id: (i - 1) * self nColumns + j;
                position: { i . j };
                possibleTiles: self tileset tiles;
                isCollapsed: false;
                sumOfWeights: mockNode sumOfWeights;
                sumOfWeightsLog: mockNode sumOfWeightsLog;
                entropy: mockNode entropy;
                yourself.

            grid addNode: node ] ].

     ^ grid
]

{ #category : 'tileset' }
WS2DGridTopology >> createEmptyTile [

	^ self subclassResponsibility
	
	
]

{ #category : 'creation' }
WS2DGridTopology >> createGraph [
	"Take the empty matrix and collapse nodes to class tile. Then restore the matrix and returns the graph"
	
	| workingGrid collapsedNodes |

	workingGrid := self emptyMatrixCheckpoint veryDeepCopy.
	collapsedNodes := (self collapseNodesToClassesIn: workingGrid).

	^ WSGraph 
		newWithStructure: workingGrid
		andCollapsedNodes: collapsedNodes 
		andTopology: self.
		
]

{ #category : 'creation' }
WS2DGridTopology >> createLayoutMatrix: aSwSystem [
	"Retrieve the embedding from the strategy (already normalized), then scale them to the number of rows and columns and transform them in indexes"
	
	| positions colX colY |
	self layoutStrategy: 
		(WSConfig placementStrategy 
			computeForSystem: aSwSystem withDimension: 2).

	positions := layoutStrategy matrix.

	colX := (positions atColumn: 1) collect: 
		[ :each | self scaleNormalizedValue: each toInnerRange: self nRows].
	
	colY := (positions atColumn: 2) collect: 
		[ :each | self scaleNormalizedValue: each toInnerRange: self nColumns].
	
	self layoutMatrix: ((PMMatrix rows: { colY . colX }) transpose).
]

{ #category : 'matrix' }
WS2DGridTopology >> createMatrixFromTileset [
	"Create the matrix containing the nodes of the graph"
	
	self emptyMatrixCheckpoint: self createEmptyMatrix.
	self createEdgesIn: self emptyMatrixCheckpoint.
	self removePossibilitiesFromBordersIn: self emptyMatrixCheckpoint
	
]

{ #category : 'matrix' }
WS2DGridTopology >> createMockNode [

	 | node |
	
    node := WSNode new possibleTiles: (self tileset tiles veryDeepCopy).
    node updateShannonEntropyFromScratch.

    ^ node
]

{ #category : 'tileset' }
WS2DGridTopology >> createPathTilesWithID: aSymbol [

	^ self subclassResponsibility 
]

{ #category : 'tileset' }
WS2DGridTopology >> createTileEdgesFrom: anOrderedCollection [ 

	^ self subclassResponsibility
]

{ #category : 'tileset' }
WS2DGridTopology >> createTileset [
	"Create the tileset for the rectangular topology"
	
	| emptyTile pathTiles |
	emptyTile := self createEmptyTile.
	pathTiles := self createAllPathTiles.
	
	self tileset addTile: emptyTile.
	self tileset addTiles: pathTiles.

]

{ #category : 'metrics' }
WS2DGridTopology >> distanceBetweenNode: aNode1 toNode: aNode2 [
	
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
WS2DGridTopology >> emptyMatrixCheckpoint [

	^ emptyMatrixCheckpoint
]

{ #category : 'accessing' }
WS2DGridTopology >> emptyMatrixCheckpoint: anObject [

	emptyMatrixCheckpoint := anObject
]

{ #category : 'calculating' }
WS2DGridTopology >> findClosestTargetNodeFor: aClass pathID: aPathID fromNode: aNode [
    "Return the closest border node among all footprints sharing aPathID, excluding aClass"

    | connectedClasses bestNode bestDistance |
    connectedClasses := self swSystem allClassesConnectedByPathID: aPathID.
    bestNode := nil.
    bestDistance := SmallInteger maxVal.
    
    connectedClasses do: [ :eachConnectedClass |
        (eachConnectedClass = aClass) ifFalse: [
				| targetFootprint |
				targetFootprint := (classFootprint at: eachConnectedClass ifAbsent: [ nil ]).
				targetFootprint ifNotNil: [ 
					| targetNode |
					targetNode := targetFootprint nodeThatIncludes: aPathID.
					targetNode ifNotNil: [ 
						| currentDistance |
						currentDistance := self distanceBetweenNode: aNode toNode: targetNode.
						currentDistance < bestDistance ifTrue: [ 
                        bestDistance := currentDistance.
                        bestNode := targetNode ]
					]
				]
			] 
		].

    ^ bestNode
]

{ #category : 'collapse' }
WS2DGridTopology >> footprintSizeFor: aClass [
	 "Return the side length N of the NxN footprint needed for aClass"
	
	| connectionsSize |
	
	connectionsSize := (self swSystem allConnectionsOf: aClass) size. 
	connectionsSize isZero ifTrue: [ ^ 1 ].
	^ (connectionsSize / 4) ceiling
]

{ #category : 'accessing' }
WS2DGridTopology >> getAtRow: i andColumn: j [
	
	^ (self emptyMatrixCheckpoint at: i) at: j
	
]

{ #category : 'accessing' }
WS2DGridTopology >> getPerimeterNodesForFootprintAt: topLeftNode size: n onGraph: aGraph [
    "Return all Moore neighbours at distance 1 from the NxN footprint starting at topLeftNode"
    
    | row col perimeterNodes |
    row := topLeftNode row.
    col := topLeftNode column.
    perimeterNodes := Set new. 
    
    col - 1 to: col + n do: [ :y |
        (aGraph isInBoundsRow: row - 1 column: y) 
            ifTrue: [ perimeterNodes add: (aGraph atRow: row - 1 atColumn: y) ].
        (aGraph isInBoundsRow: row + n column: y) 
            ifTrue: [ perimeterNodes add: (aGraph atRow: row + n atColumn: y) ] ].
    
    row to: row + n - 1 do: [ :x |
        (aGraph isInBoundsRow: x column: col - 1) 
            ifTrue: [ perimeterNodes add: (aGraph atRow: x atColumn: col - 1) ].
        (aGraph isInBoundsRow: x column: col + n) 
            ifTrue: [ perimeterNodes add: (aGraph atRow: x atColumn: col + n) ] ].
    
    ^ perimeterNodes
]

{ #category : 'copying' }
WS2DGridTopology >> initialNodes [ 
	
	^ self emptyMatrixCheckpoint matrix flattened
]

{ #category : 'initialization' }
WS2DGridTopology >> initialize [ 
	
	super initialize.
	self classFootprint: Dictionary new
]

{ #category : 'creation' }
WS2DGridTopology >> initializeWith: aSwSystem [
	"Initialize all the fileds of the topology given an entities set"
	
	self swSystem: aSwSystem.
			
	self createLayoutMatrix: aSwSystem.
	self createTileset.
	self createMatrixFromTileset.

]

{ #category : 'drag and drop' }
WS2DGridTopology >> isFreeCell: aNode forClass: aClass withPathIDs: pathIDs [

    | tile |

    tile := aNode tileInWhichCollapsed.
    tile isEmptyTile ifTrue: [ ^ true ].
    (tile isClassTile and: [ tile wsClass = aClass ]) ifTrue: [ ^ true ].
    (tile isPathTile and: [ pathIDs includes: tile pathID ]) ifTrue: [ ^ true ].

    ^ false
]

{ #category : 'accessing' }
WS2DGridTopology >> isValidPosition: aPoint [
	
	^ (aPoint x between: 1 and: self nRows) and: [ aPoint y between: 1 and: self nColumns ]
]

{ #category : 'testing' }
WS2DGridTopology >> isValidToMove: aClass toNode: aNode onGraph: aGraph [

	| row col n perimeterNodes |
	n := (self classFootprint at: aClass) sideLength.
	row := aNode row.
	col := aNode column.
	(aGraph isInBoundsRow: row + n - 1 column: col + n - 1) ifFalse: [
		^ false ].
	row to: row + n - 1 do: [ :eachRow |
			col to: col + n - 1 do: [ :eachCol |
					| node |
					node := aGraph atRow: eachRow atColumn: eachCol.
					(self
						 isFreeCell: node
						 forClass: aClass
						 withPathIDs: (self swSystem pathIDsOf: aClass)) ifFalse: [
						^ false ] ] ].
			
	perimeterNodes := self
		getPerimeterNodesForFootprintAt: aNode
		size: n
		onGraph: aGraph.
		
	^ perimeterNodes noneSatisfy: [ :eachNeighbour |
			  | tile |
			  tile := eachNeighbour tileInWhichCollapsed.
			  tile isClassTile and: [ tile wsClass ~= aClass ] ]
]

{ #category : 'accessing' }
WS2DGridTopology >> layoutMatrix [

	^ layoutMatrix
]

{ #category : 'accessing' }
WS2DGridTopology >> layoutMatrix: anObject [

	layoutMatrix := anObject
]

{ #category : 'drag and drop' }
WS2DGridTopology >> moveClass: aClass toNode: aNode inGraph: aGraph [
	"Given a class, it changes its position to aNode"
	| touchedNodes footprint oldNodes newNodes |
	aGraph topology: self.
	touchedNodes := OrderedCollection new.
	footprint := self classFootprint at: aClass.
	touchedNodes addAll: footprint nodes.
	
	 oldNodes := footprint nodes veryDeepCopy .
    footprint nodes do: [ :eachNode |
        eachNode footPrint: nil.
        eachNode collapseTo: self createEmptyTile ]. 

	 newNodes := aGraph structure collectFootprintFrom: aNode size: footprint sideLength.
    footprint originNode: aNode.
    footprint nodes: newNodes.
    newNodes do: [ :eachNode | eachNode footPrint: footprint ].

	   oldNodes withIndexDo: [ :oldNode :i |
        (newNodes at: i) collapseTo: oldNode tileInWhichCollapsed ].

	touchedNodes 
		addAll: newNodes;
		addAll: (aGraph optimizePaths: (self swSystem pathIDsOf: aClass)).

	^ touchedNodes 
]

{ #category : 'accessing' }
WS2DGridTopology >> nColumns [

	^ nColumns
]

{ #category : 'accessing' }
WS2DGridTopology >> nColumns: anObject [

	nColumns := anObject
]

{ #category : 'accessing' }
WS2DGridTopology >> nRows [

	^ nRows
]

{ #category : 'accessing' }
WS2DGridTopology >> nRows: anObject [

	nRows := anObject
]

{ #category : 'collapse' }
WS2DGridTopology >> pickNodeForClass: aClass footprintSize: n in: aGrid [
    "Return the top-left node of a valid NxN footprint"
    
    | pos target candidates |
    pos := self layoutMatrix rowAt: aClass id.
    target := aGrid atRow: (pos first) atColumn: (pos last).

    (aGrid 
		isValidTopLeft: target 
		forSize: n 
		withOffset: self class safetyMooreRadius) 
			ifTrue: [ ^ target ].
    
    candidates := aGrid 
		searchOutwardFrom: target 
		forSize: n 
		defaultOffset: self class safetyMooreRadius.
		
	^ self selectBestCandidate: candidates forClass: aClass footprintSize: n in: aGrid.
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromBordersIn: aGrid [
	"Remove the possibilities from border nodes in order that a path cannot exit the grid"
	self removePossibilitiesFromFirstRowIn: aGrid.
	self removePossibilitiesFromLastRowIn: aGrid.
	self removePossibilitiesFromFirstColumnIn: aGrid.
	self removePossibilitiesFromLastColumnIn: aGrid.

]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromFirstColumnIn: aGrid [
	
	^ self subclassResponsibility 
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromFirstRowIn: aGrid [
	
	 ^ self subclassResponsibility 
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromLastColumnIn: aGrid [
	
	^ self subclassResponsibility 
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromLastRowIn: aGrid [
	
	^ self subclassResponsibility 
]

{ #category : 'calculating' }
WS2DGridTopology >> scaleNormalizedValue: aValue toInnerRange: n [
    "Scale a normalized value [0,1] to [2, n-1], excluding border positions"

    ^ ((aValue * (n - 3)) rounded) + 2
]

{ #category : 'calculating' }
WS2DGridTopology >> seedPathTargetsFor: aClass footprint: aFootprint [
    "For each node of aFootprint, seed pathTargets for each pathID on its tile edges"

    aFootprint nodes do: [ :eachNode |
        (eachNode tileInWhichCollapsed edges) do: [ :edgeSymbols |
				| symbol |
				symbol := edgeSymbols first.
            (WSConfig isPathID: symbol) ifTrue: [
                | targetNode |
                targetNode := self 
                    findClosestTargetNodeFor: aClass 
                    pathID: symbol
                    fromNode: eachNode.
                targetNode ifNotNil: [
                    eachNode pathTargets at: symbol put: targetNode ] ] ] ]
]

{ #category : 'collapse' }
WS2DGridTopology >> selectBestCandidate: candidates forClass: aClass footprintSize: n in: aGrid [
	
	^ self subclassResponsibility 
]
