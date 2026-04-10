"
It creates the graph for a rectangular grid. You can set the dimension with a point (ex: 10 @ 5)
"
Class {
	#name : 'WS2DRectangularGridTopology',
	#superclass : 'WS2DGridTopology',
	#category : 'Wassis-Topology',
	#package : 'Wassis',
	#tag : 'Topology'
}

{ #category : 'accessing' }
WS2DRectangularGridTopology class >> allSymbols [
	
	^ OrderedCollection 
		with: self upSymbol 
		with: self leftSymbol 
		with: self rightSymbol 
		with: self downSymbol 
]

{ #category : 'instance creation' }
WS2DRectangularGridTopology class >> createOppositeDirections [

	^ 	(Dictionary new
			at: self upSymbol put: self downSymbol;
			at: self leftSymbol put: self rightSymbol; 
			at: self rightSymbol put: self leftSymbol; 
			at: self downSymbol put: self upSymbol; 
			yourself
		).

]

{ #category : 'directionSymbol' }
WS2DRectangularGridTopology class >> downSymbol [
	
	^ #down
]

{ #category : 'as yet unclassified' }
WS2DRectangularGridTopology class >> horizontalSymbols [
	
	^ OrderedCollection 
		with: self leftSymbol 
		with: self rightSymbol
]

{ #category : 'directionSymbol' }
WS2DRectangularGridTopology class >> leftSymbol [
	
	^ #left
]

{ #category : 'as yet unclassified' }
WS2DRectangularGridTopology class >> positionDirection [ 
	"Returns a dictionary, the key is the direction, the value is the index in the edges"
	
	^ Dictionary new
		at: (self upSymbol ) put: 1;
		at: (self leftSymbol ) put: 2;
		at: (self rightSymbol ) put: 3;
		at: (self downSymbol ) put: 4;
		yourself 
]

{ #category : 'directionSymbol' }
WS2DRectangularGridTopology class >> rightSymbol [
	
	^ #right
]

{ #category : 'directionSymbol' }
WS2DRectangularGridTopology class >> upSymbol [
	
	^ #up
]

{ #category : 'as yet unclassified' }
WS2DRectangularGridTopology class >> verticalSymbols [
	
	^ OrderedCollection 
		with: self upSymbol 
		with: self downSymbol
]

{ #category : 'weight' }
WS2DRectangularGridTopology >> addWeightsFor: aValue positive: posDir negative: negDir into: aDictionary [

    aValue >= 0
        ifTrue: [ 
            aDictionary at: posDir put: aValue.
            aDictionary at: negDir put: 0 ]
        ifFalse: [ 
            aDictionary at: posDir put: 0.
            aDictionary at: negDir put: aValue abs ]
]

{ #category : 'weight' }
WS2DRectangularGridTopology >> computeDirectionsFor: deltaX and: deltaY [
    "Returns an OrderedCollection of directions sorted by preference. Note that deltaX can be equal to deltaY but they cannot be both 0 at the same time"
    
    | result remaining horizontal vertical |
    result := OrderedCollection new.
    horizontal := deltaX >= 0 ifTrue: [ self class rightSymbol ] ifFalse: [ self class leftSymbol ].
    vertical   := deltaY >= 0 ifTrue: [ self class downSymbol ]  ifFalse: [ self class upSymbol ].
	
	deltaX abs = deltaY abs 
		ifTrue: [ result addAll: ({ horizontal . vertical } shuffled) ]
		ifFalse: [ 
			deltaX abs > deltaY abs
				ifTrue: [ 
					result add: horizontal.
					deltaY = 0
						ifTrue: [ result addAll: ((self class verticalSymbols) shuffled)]
						ifFalse: [ result add: vertical ]
				]
				ifFalse: [ 
					result add: vertical.
					deltaX = 0
						ifTrue: [ result addAll: ((self class horizontalSymbols) shuffled)]
						ifFalse: [ result add: horizontal ]
				]
		].
    
    remaining := self class allSymbols asOrderedCollection.
    remaining removeAll: result.
    result addAll: remaining shuffled.
    
    ^ result
]

{ #category : 'tilesetDeprecated' }
WS2DRectangularGridTopology >> createClassTile: aClass [
	"Create the class tile and returns it"
	
	| edges ees |
	ees := self class emptyEdgeSymbol.
	edges := OrderedCollection new: 4 withAll: ees.

	(self swSystem allConnectionsOf: aClass) do: [ :eachClass |
		| pathID directions |
		directions :=  self 
			preferredDirectionsFrom: (self classNodes at: aClass) 
			to: (self classNodes at: eachClass).
			
		pathID := self swSystem pathIDOf: aClass and: eachClass.
		
		directions detect: [ :dir | (edges at: dir) = ees ]
           ifFound: [ :dir | edges at: dir put: pathID ]
	].
	
	^ WSClassTile 
		withClass: aClass
		andEdges: (self createTileEdgesFrom: edges)
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createClassTiles: aClass forFootprint: aFootprint [
    "Returns a Dictionary WSNode -> WSClassTile with exits distributed across the footprint"
    
    | connectionDirections slots nodeEdges ees result |
    ees := self class emptyEdgeSymbol.
    
    "For each connection compute the preferred direction array"
    connectionDirections := Dictionary new.
    (self swSystem allConnectionsOf: aClass) do: [ :eachConnectedClass |
        | sourceCenter targetCenter directions |
        sourceCenter := aFootprint centerNode.
        targetCenter := (self classNodes at: eachConnectedClass) centerNode.
        directions := self preferredDirectionsFrom: sourceCenter to: targetCenter.
        connectionDirections at: eachConnectedClass put: directions ].
    
    "Build pool of available slots (node -> direction)"
    slots := OrderedCollection new.
    aFootprint nodes do: [ :aNode |
        (self exposedDirectionsOf: aNode) do: [ :dir |
            slots add: aNode -> dir ] ].
    
    "Initialize empty edges for each node"
    nodeEdges := Dictionary new.
    aFootprint nodes do: [ :aNode |
        nodeEdges at: aNode put: Dictionary new ].
    
    "Assign each connection to the best available slot"
    connectionDirections keysAndValuesDo: [ :eachConnectedClass :directions |
        | bestSlot pathID |
        bestSlot := directions 
            detect: [ :dir | slots anySatisfy: [ :slot | slot value = dir ] ]
            ifNone: [ nil ].
        
        bestSlot ifNotNil: [ :dir |
            | slot |
            slot := slots detect: [ :s | s value = dir ].
            pathID := self swSystem pathIDOf: aClass and: eachConnectedClass.
            (nodeEdges at: slot key) at: dir put: pathID.
            slots remove: slot ] ].
    
		"Build one WSClassTile per node"
		result := Dictionary new.
		nodeEdges keysAndValuesDo: [ :aNode :dirPathDict |
		    | edges posDir |
		    posDir := self class positionDirection.
		    edges := OrderedCollection new: 4 withAll: ees.
		    
		    dirPathDict keysAndValuesDo: [ :dir :pathID |
		        edges at: (posDir at: dir) put: pathID ].
		    
		    result at: aNode put: (WSClassTile withClass: aClass andEdges: (self createTileEdgesFrom: edges)) ].

		^ result
]

{ #category : 'matrix' }
WS2DRectangularGridTopology >> createEdgesOfNodes [
	"Given a matrix of nodes, assign the edges for each node"
	
	1 to: self nRows do: [ :i |
		1 to: self nColumns do: [ :j |
			| eachNode | 
			eachNode := self getAtRow: i andColumn: j.
			
			"Connect to the right neighbour and viceversa"
			j < self nColumns ifTrue: [ 
				self connect: eachNode 
					  to: (self getAtRow: i andColumn: (j + 1)) 
					  withDirection: (self class rightSymbol)
			].
			
			"Connect to the down neighbour and viceversa"
			i < self nRows ifTrue: [ 
				self connect: eachNode 
					  to: (self getAtRow: (i + 1) andColumn: j)
					  withDirection: (self class downSymbol )
			]
		]
	]
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createEmptyTile [
	"Create the empty tile for the rectangular grid topology"
	
	| emptyEdgeSymbol |
	
	emptyEdgeSymbol := self class emptyEdgeSymbol.
	
	^ WSEmptyTile withEdges: 
		(self createTileEdgesFrom: { 
			emptyEdgeSymbol . 
			emptyEdgeSymbol .
			emptyEdgeSymbol .
			emptyEdgeSymbol }
		 )
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createPathTilesWithID: aSymbol [
    "Given a pathID (a symbol) create the path tiles to connect two classes"
    | empty path tileSpecs pathTiles |
    
    empty := self class emptyEdgeSymbol.
    path  := aSymbol.
    
    tileSpecs := {
        { 1. 50. { empty. path.  path.  empty } }.
        { 2. 50. { path.  empty. empty. path  } }.
        { 3. 25. { path.  empty. path.  empty } }.
        { 4. 25. { path.  path.  empty. empty } }.
        { 5. 25. { empty. empty. path.  path  } }.
        { 6. 25. { empty. path.  empty. path  } }.
    }.
    
	pathTiles := (tileSpecs collect: [ :spec |
		WSPathTile 
			withID: spec first
			withWeight: spec second
			withEdges: (self createTileEdgesFrom: (spec last))
			withPathID: aSymbol
   	]).

	self tileset pathTiles at: aSymbol put: pathTiles. 

	^ pathTiles 
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createTileEdgesFrom: anOrderedCollection [
	"For the rectangular grid topology, it creates the edges for a tile in the order up, left, right, down"
	
	^ (Dictionary new
		at: (self class) upSymbol put: (OrderedCollection with:  anOrderedCollection first);
		at: (self class) leftSymbol put: (OrderedCollection with:  anOrderedCollection second);
		at: (self class) rightSymbol put: (OrderedCollection with:  anOrderedCollection third);
		at: (self class) downSymbol put: (OrderedCollection with:  anOrderedCollection last);
		yourself 
  ).
]

{ #category : 'collapse' }
WS2DRectangularGridTopology >> exposedDirectionsOf: aNode [
    "Return the directions of aNode that face outside the footprint"
    
    | originRow originColumn exposed footPrint |
	 footPrint := aNode footPrint.
    originRow := footPrint originNode row. 
    originColumn := footPrint originNode column.
    exposed := OrderedCollection new.
    
    aNode row = originRow ifTrue: [ exposed add: self class upSymbol ].
    aNode row = (originRow + footPrint sideLength - 1) ifTrue: [ exposed add: self class downSymbol  ].
    aNode column = originColumn ifTrue: [ exposed add: self class leftSymbol ].
    aNode column = (originColumn + footPrint sideLength - 1) ifTrue: [ exposed add: self class rightSymbol ].
    
    ^ exposed
]

{ #category : 'initialization' }
WS2DRectangularGridTopology >> initialize [

	super initialize.
	self visualizer:WS2DRectangularGridVisualizer new
]

{ #category : 'weight' }
WS2DRectangularGridTopology >> preferredDirectionsFrom: sourceNode to: targetNode [
	"Create a list of directions (up, left, right, down), the order of the directions is given by a preferred choice based on the relative position of the target compared with the position of the source"
	
    | deltaX deltaY |
    deltaX := targetNode column - sourceNode column.
    deltaY := targetNode row - sourceNode row.
    ^ self computeDirectionsFor: deltaX and: deltaY
	
	
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromFirstColumn [

	1 to: self nRows do: [ :i |
		(self getAtRow: i andColumn: 1) keepTilesWithIDin: #( 0 2 3 5 ) ].
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromFirstRow [

	1 to: self nColumns do: [ :j |
			(self getAtRow: 1 andColumn: j) keepTilesWithIDin: #( 0 1 5 6 ) ].
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromLastColumn [

	1 to: self nRows do: [ :i |
			(self getAtRow: i andColumn: self nColumns) keepTilesWithIDin: #( 0 2 4 6 ) ]
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromLastRow [

	1 to: self nColumns do: [ :j |
		(self getAtRow: self nRows andColumn: j) keepTilesWithIDin: #( 0 1 3 4 ) ].
]

{ #category : 'deprecated' }
WS2DRectangularGridTopology >> selectNextDirectionIn: aDictionary [
	"Weighted choice of the next direction"

	| sumW random |
	sumW := 0.
	aDictionary do: [ :eachValue | sumW := sumW + eachValue ].
	sumW = 0 ifTrue: [ ^ aDictionary keys atRandom ].
	
	random := sumW atRandom.
	
	aDictionary keysAndValuesDo: [ :eachKey :eachValue | 
		random := random - eachValue.
		random <= 0 ifTrue: [ ^ eachKey ] ]
]
