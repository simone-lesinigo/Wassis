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
WS2DRectangularGridTopology >> computeCircularWeights: deltaX and: deltaY [
	"The choice is not greedy but the gretaer probability is assigned to the most convenient direction"

	| magnitude weights |
	
	magnitude := ((deltaX * deltaX) + (deltaY * deltaY)) sqrt.
	weights := Dictionary new.
	
	weights at: self class upSymbol put: ((((deltaY negated / magnitude) + 1) / 2) * 100) rounded;
		     at: self class downSymbol put: ((((deltaY / magnitude) + 1) / 2) * 100) rounded;
           at: self class rightSymbol put: ((((deltaX / magnitude) + 1) / 2) * 100) rounded;
           at: self class leftSymbol put: ((((deltaX negated / magnitude) + 1) / 2) * 100) rounded.
	
	^ weights 
]

{ #category : 'weight' }
WS2DRectangularGridTopology >> computeRigidWeights: deltaX and: deltaY [
    "Returns an OrderedCollection of directions sorted by preference"
    
    | primary secondary remaining result |
    result := OrderedCollection new.
    
    primary  := deltaX abs >= deltaY abs
        ifTrue:  [ deltaX >= 0 ifTrue: [ self class rightSymbol ] ifFalse: [ self class leftSymbol ] ]
        ifFalse: [ deltaY >= 0 ifTrue: [ self class downSymbol ]  ifFalse: [ self class upSymbol ] ].
    
    secondary := deltaX abs >= deltaY abs
        ifTrue:  [ deltaY >= 0 ifTrue: [ self class downSymbol ]  ifFalse: [ self class upSymbol ] ]
        ifFalse: [ deltaX >= 0 ifTrue: [ self class rightSymbol ] ifFalse: [ self class leftSymbol ] ].
    
    remaining := { self class upSymbol. self class downSymbol. 
                   self class leftSymbol. self class rightSymbol } asOrderedCollection.
    remaining remove: primary; remove: secondary.
    remaining := remaining shuffled.
    
    result add: primary; add: secondary; addAll: remaining.

    ^ result
]

{ #category : 'deprecated' }
WS2DRectangularGridTopology >> computeWeightsFrom: sourceNode to: targetNode [
	"Assigns at each direction the weight (given by the distance)"

	| deltaX deltaY |
	deltaX := targetNode column - sourceNode column.
	deltaY := targetNode row - sourceNode position row.
	
	"^ self computeCircularWeights: deltaX and: deltaY."
	^ self computeRigidWeights: deltaX and: deltaY.



]

{ #category : 'tilesetDeprecated' }
WS2DRectangularGridTopology >> createClassTile: aClass [
	"Create the class tile and returns it"
	
	| edges ees |
	ees := self class emptyEdgeSymbol.
	edges := OrderedCollection new: 4 withAll: ees.

	(self swSystem allConnectionsOf: aClass) do: [ :eachClass |
		| pathID directions |
		directions :=  
			self weightedDirection: (self classNodes at: aClass) and: (self classNodes at: eachClass).
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
        directions := self weightedDirection: sourceCenter and: targetCenter.
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
    
    | row column originRow originColumn exposed footPrint |
	 footPrint := aNode footPrint.
    row := aNode row. 
    column := aNode column.
    originRow := footPrint originNode row. 
    originColumn := footPrint originNode column.
    exposed := OrderedCollection new.
    
    row = originRow ifTrue: [ exposed add: self class upSymbol ].
    row = (originRow + footPrint sideLength - 1) ifTrue: [ exposed add: self class downSymbol  ].
    column = originColumn ifTrue: [ exposed add: self class leftSymbol ].
    column = (originColumn + footPrint sideLength - 1) ifTrue: [ exposed add: self class rightSymbol ].
    
    ^ exposed
]

{ #category : 'initialization' }
WS2DRectangularGridTopology >> initialize [

	super initialize.
	self visualizer:WS2DRectangularGridVisualizer new
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

{ #category : 'weight' }
WS2DRectangularGridTopology >> weightedDirection: sourceNode and: targetNode [
	"Create a list of numbers (1, 2, 3, 4) where each one represents a direction (up, left, right, down), the order of the numbers is given by a weighted choice based on the relative position of the target compared with the position of the source"
	
    | deltaX deltaY |
    deltaX := targetNode position second - sourceNode position second.
    deltaY := targetNode position first - sourceNode position first.
    ^ self computeRigidWeights: deltaX and: deltaY
	
	
]
