"
Superclasses of all the topologies that relies on a matrix to create the graph
"
Class {
	#name : 'WS2DGridTopology',
	#superclass : 'WSTopology',
	#instVars : [
		'matrix',
		'nRows',
		'nColumns',
		'layoutMatrix',
		'classNodes'
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
WS2DGridTopology class >> defaultOffset [
	
	^ 2
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
WS2DGridTopology >> assignNodesToClasses [
    "For each class select the node in which it will be placed"
    
    self swSystem classes do: [ :eachClass | 
        | sideLength originNode footprintNodes footprint |
        sideLength := self footprintSizeFor: eachClass.
        originNode := self pickNodeForClass: eachClass footprintSize: sideLength.
        footprintNodes := self collectFootprintFrom: originNode size: sideLength.
        
        footprint := WSFootprint new
            wsClass: eachClass;
            nodes: footprintNodes;
            originNode: originNode;
            sideLength: sideLength;
            yourself.
        
        footprintNodes do: [ :each | 
            each isCollapsed: true.
            each footPrint: footprint ].
        
        self classNodes at: eachClass put: footprint ]
]

{ #category : 'accessing' }
WS2DGridTopology >> classNodes [

	^ classNodes
]

{ #category : 'accessing' }
WS2DGridTopology >> classNodes: anObject [

	classNodes := anObject
]

{ #category : 'collapse' }
WS2DGridTopology >> collapseNodesToClasses [
    "Collapse some nodes to classes and returns them"
    
    | result |
    result := OrderedCollection new.
    self assignNodesToClasses.
    self classNodes keysAndValuesDo: [ :eachClass :eachFootprint |
        | nodesToTile |
        nodesToTile := self createClassTiles: eachClass forFootprint: eachFootprint.

        nodesToTile keysAndValuesDo: [ :eachNode :eachTile |
            result add: (eachNode collapseToClassTile: eachTile) ] ].
    
    ^ result
]

{ #category : 'collapse' }
WS2DGridTopology >> collectFootprintFrom: originNode size: sideLength [
    "Return all nodes in the NxN block with originNode as top-left"

    | result row col |
    result := OrderedCollection new.
    row := originNode row.
    col := originNode column.
    0 to: sideLength - 1 do: [ :dr |
        0 to: sideLength - 1 do: [ :dc |
            result add: (self getAtRow: (row + dr) andColumn: (col + dc)) ] ].
    ^ result
]

{ #category : 'tileset' }
WS2DGridTopology >> createAllPathTiles [
	"Create all the necessary path tiles for all entities and returns them"

	| pathTiles |
	
	pathTiles := OrderedCollection new.
	
	self swSystem classesPathIDs do: [ :pathID |
			pathTiles addAll: (self createPathTilesWithID: pathID) ].
	
	^ pathTiles 
]

{ #category : 'tileset' }
WS2DGridTopology >> createClassTiles: aClass forFootprint: aFootprint [

	^ self subclassResponsibility 
]

{ #category : 'matrix' }
WS2DGridTopology >> createEdgesOfNodes [

	^ self subclassResponsibility
]

{ #category : 'matrix' }
WS2DGridTopology >> createEmptyMatrix [
	"Creates the nodes and save them in the matrix. All the nodes have the same entropy and contain all the possibile tiles from the tileset"
	
	| mockNode |
	mockNode := self createMockNode.
	
	self matrix: 
		((1 to: self nRows) collect: [ :i |
        (1 to: self nColumns) collect: [ :j |
            WSNode new
                id: (i - 1) * self nColumns + j;
					 position: { i . j };
                possibleTiles: self tileset tiles;
                isCollapsed: false;
                sumOfWeights: mockNode sumOfWeights;
                sumOfWeightsLog: mockNode sumOfWeightsLog;
                entropy: mockNode entropy;
                yourself ] ]).
]

{ #category : 'tileset' }
WS2DGridTopology >> createEmptyTile [

	^ self subclassResponsibility
	
	
]

{ #category : 'creation' }
WS2DGridTopology >> createGraph [
	"Take the empty matrix and collapse nodes to class tile. Then restore the matrix and returns the graph"
	
	| emptyMatrixCheckpoint collapsedNodes nodes |
	
	emptyMatrixCheckpoint := self matrix veryDeepCopy.
	collapsedNodes := (self collapseNodesToClasses).

	nodes := (OrderedCollection new addAll: self matrix; yourself).
	self matrix: emptyMatrixCheckpoint.
	
	^ WSGraph 
		newWithNodes: nodes 
		andCollapsedNodes: collapsedNodes 
		andTopology: self

]

{ #category : 'creation' }
WS2DGridTopology >> createLayoutMatrix: aSwSystem [
	"Retrieve the embedding from the strategy (already normalized), then scale them to the number of rows and columns and transform them in indexes"
	
	| positions colX colY |
	positions :=
		(WSMDSLayoutStrategy 
			computeForClasses: aSwSystem classes withDimension: 2).
	
	colX := (positions atColumn: 1) collect: 
		[ :each | self scaleNormalizedValue: each toInnerRange: self nRows].
	
	colY := (positions atColumn: 2) collect: 
		[ :each | self scaleNormalizedValue: each toInnerRange: self nColumns].
	
	self layoutMatrix: ((PMMatrix rows: { colX . colY }) transpose).
]

{ #category : 'matrix' }
WS2DGridTopology >> createMatrixFromTileset [
	"Create the matrix containing the nodes of the graph"
	
	self createEmptyMatrix.
	self createEdgesOfNodes.
	self removePossibilitiesFromBorders.
	
	
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
	emptyTile := self createEmptyTile .
	pathTiles := self createAllPathTiles .
	
	self tileset addTile: emptyTile.
	self tileset addTiles: pathTiles.

]

{ #category : 'collapse' }
WS2DGridTopology >> footprintSizeFor: aClass [
	 "Return the side length N of the NxN footprint needed for aClass"
	
	| connectionsSize |
	
	connectionsSize := (self swSystem allConnectionsPerClass at: aClass) size. 
	
	^ (connectionsSize / 4) ceiling
]

{ #category : 'accessing' }
WS2DGridTopology >> getAtRow: i andColumn: j [
	
	^ (self matrix at: i) at: j
	
]

{ #category : 'accessing' }
WS2DGridTopology >> getNeighboursOf: aNode atLevel: aNumber [
    "Return the Moore neighbours at exactly distance aNumber from aNode"
    
    | posX posY neighbours |
    posX := aNode row.
    posY := aNode column.
    neighbours := OrderedCollection new.
    
    (posX - aNumber) to: (posX + aNumber) do: [ :x |
        (posY - aNumber) to: (posY + aNumber) do: [ :y |
            ((x = (posX - aNumber) or: [ x = (posX + aNumber) ]) or: [
              y = (posY - aNumber) or: [ y = (posY + aNumber) ]])
                ifTrue: [
                    (self isValidPosition: x @ y) ifTrue: [
                        neighbours add: (self getAtRow: x andColumn: y) ] ] ] ].
    
    ^ neighbours
]

{ #category : 'initialization' }
WS2DGridTopology >> initialize [ 
	
	super initialize.
	self classNodes: Dictionary new
]

{ #category : 'creation' }
WS2DGridTopology >> initializeWith: aSwSystem [
	"Initialize all the fileds of the topology given an entities set"
	
	self swSystem: aSwSystem.
			
	self createLayoutMatrix: aSwSystem.
	self createTileset.
	self createMatrixFromTileset.

]

{ #category : 'collapse' }
WS2DGridTopology >> isInBoundsRow: row col: col [

	^ (row between: 1 and: self nRows) and: [ col between: 1 and: self nColumns ]
]

{ #category : 'accessing' }
WS2DGridTopology >> isValidPosition: aPoint [
	
	^ (aPoint x between: 2 and: self nRows - 1) and: [ aPoint y between: 2 and: self nColumns - 1]
]

{ #category : 'collapseDeprecated' }
WS2DGridTopology >> isValidTarget: aNode [
    "A valid target is not collapsed and has no collapsed Moore neighbours"

    ^ aNode isNotCollapsed and: [
        (self getNeighboursOf: aNode atLevel: 1) allSatisfy: [ :each | each isNotCollapsed ] ]

]

{ #category : 'collapse' }
WS2DGridTopology >> isValidTopLeft: aNode forSize: n withOffset: offset [
    "A valid top-left node has:
     - the NxN footprint entirely within bounds and not collapsed
     - a 2 (default offset) cell border around the footprint entirely not collapsed"
    
   | minRow maxRow minCol maxCol |
	minRow := (aNode row) - offset.
	minCol := (aNode column) - offset.
	maxRow := (aNode row) + n + offset - 1.
	maxCol := (aNode column) + n + offset - 1.

	(self isInBoundsRow: minRow col: minCol ) ifFalse: [ ^ false ].
	(self isInBoundsRow: maxRow col: maxCol ) ifFalse: [ ^ false ].

	minRow to: maxRow do: [ :eachRow |
	    minCol to: maxCol do: [ :eachCol |
	        (self getAtRow: eachRow andColumn: eachCol) isCollapsed 
	            ifTrue: [ ^ false ] ] ].

	^ true
]

{ #category : 'accessing' }
WS2DGridTopology >> layoutMatrix [

	^ layoutMatrix
]

{ #category : 'accessing' }
WS2DGridTopology >> layoutMatrix: anObject [

	layoutMatrix := anObject
]

{ #category : 'accessing' }
WS2DGridTopology >> matrix [

	^ matrix
]

{ #category : 'accessing' }
WS2DGridTopology >> matrix: anObject [

	matrix := anObject
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

{ #category : 'collapseDeprecated' }
WS2DGridTopology >> pickNodeForClass: aClass [
    "Return a non collapsed node with no collapsed Moore neighbours"
    
   | pos posX posY target |
   pos := self layoutMatrix rowAt: aClass id.
 	posX := pos first.
   posY := pos last.

   target := self getAtRow: posX andColumn: posY.
    
   (self isValidTarget: target) ifTrue: [ ^ target ].
    
   ^ self searchOutwardFrom: target
]

{ #category : 'collapse' }
WS2DGridTopology >> pickNodeForClass: aClass footprintSize: n [
    "Return the top-left node of a valid NxN footprint"
    
    | pos target |
    pos := self layoutMatrix rowAt: aClass id.
    target := self getAtRow: (pos first) andColumn: (pos last).
    
    (self isValidTopLeft: target forSize: n withOffset: self class defaultOffset) 
		ifTrue: [ ^ target ].
    
    ^ self searchOutwardFrom: target forSize: n
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromBorders [
	"Remove the possibilities from border nodes in order that a path cannot exit the grid"
    self removePossibilitiesFromFirstRow.
    self removePossibilitiesFromLastRow.
    self removePossibilitiesFromFirstColumn.
    self removePossibilitiesFromLastColumn	

]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromFirstColumn [
	
	^ self subclassResponsibility 
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromFirstRow [
	
	 ^ self subclassResponsibility 
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromLastColumn [
	
	^ self subclassResponsibility 
]

{ #category : 'removing' }
WS2DGridTopology >> removePossibilitiesFromLastRow [
	
	^ self subclassResponsibility 
]

{ #category : 'calculating' }
WS2DGridTopology >> scaleNormalizedValue: aValue toInnerRange: n [
    "Scale a normalized value [0,1] to [2, n-1], excluding border positions"

    ^ ((aValue * (n - 3)) rounded) + 2
]

{ #category : 'collapseDeprecated' }
WS2DGridTopology >> searchOutwardFrom: aNode [
    "Expand outward from aPoint until a valid node positon is found"

    | candidates level maxLevel |
    candidates := OrderedCollection new.
    level := 2.
    maxLevel := (self nRows max: self nColumns) // 2.
    
    [ candidates isEmpty and: [ level <= maxLevel ] ] whileTrue: [
        candidates := (self getNeighboursOf: aNode atLevel: level)
            select: [ :node | self isValidTarget: node].

        level := level + 1 ].
    
    candidates ifEmpty: [ self error: 'No valid node found' ].

    ^ candidates shuffled first
]

{ #category : 'collapse' }
WS2DGridTopology >> searchOutwardFrom: aNode forSize: n [
    "Expand outward from aNode until a valid top-left position is found"
    
    | candidates level maxLevel |
    candidates := OrderedCollection new.
    level := 2.
    maxLevel := (self nRows max: self nColumns) // 2.
    
    [ candidates isEmpty and: [ level <= maxLevel ] ] whileTrue: [
	
        candidates := 
		   		(self getNeighboursOf: aNode atLevel: level)
            select: [ :node | self isValidTopLeft: node forSize: n withOffset: self class defaultOffset].

        level := level + 1 ].
    
    candidates ifEmpty: [ self error: 'No valid node found' ].

    ^ candidates shuffled first
]
