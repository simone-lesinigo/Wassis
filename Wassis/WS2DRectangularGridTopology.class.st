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
	"Compute the weights using a greedy choice"
	
	| weights |
	weights := Dictionary new.
	
   self addWeightsFor: deltaX
         positive: self class rightSymbol 
         negative: self class leftSymbol 
         into: weights.

    self addWeightsFor: deltaY
         positive: self class downSymbol 
         negative: self class upSymbol 
         into: weights.

	^ weights 
]

{ #category : 'weight' }
WS2DRectangularGridTopology >> computeWeightsFrom: sourceNode to: targetNode [
	"Assigns at each direction the weight (given by the distance)"

	| deltaX deltaY |
	deltaX := targetNode position second - sourceNode position second.
	deltaY := targetNode position first - sourceNode position first.
	
	"^ self computeCircularWeights: deltaX and: deltaY."
	^ self computeRigidWeights: deltaX and: deltaY.



]

{ #category : 'tileset' }
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
			at: (self class) upSymbol put: { anOrderedCollection first };
			at: (self class) leftSymbol put: {  anOrderedCollection at: 2 };
			at: (self class) rightSymbol put: { anOrderedCollection at: 3};
			at: (self class) downSymbol put: { anOrderedCollection last };
			yourself 
	  ).
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

{ #category : 'weight' }
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
	
	| weightedDir posDir res |
	res := OrderedCollection new.
	
	weightedDir := self computeWeightsFrom: sourceNode to: targetNode.
	posDir := self class positionDirection.
	 
	[ weightedDir isEmpty ] whileFalse: [ 
		| dir |
		dir := self selectNextDirectionIn: weightedDir.
		weightedDir removeKey: dir.
		res add: (posDir at: dir)
	].

	^ res
	
	
]
