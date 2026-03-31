"
It creates the graph for a hexagonal grid with flat-top. You can set the dimension with a point (ex: 10@5)
"
Class {
	#name : 'WS2DHexGridTopology',
	#superclass : 'WS2DGridTopology',
	#category : 'Wassis-Topology',
	#package : 'Wassis',
	#tag : 'Topology'
}

{ #category : 'instance creation' }
WS2DHexGridTopology class >> createOppositeDirections [

	^ 	(Dictionary new
			at: self upSymbol put: self downSymbol;
			at: self upLeftSymbol put: self downRightSymbol; 
			at: self upRightSymbol put: self downLeftSymbol; 
			at: self downSymbol put: self upSymbol; 
			at: self downLeftSymbol put: self upRightSymbol; 
			at: self downRightSymbol put: self upLeftSymbol; 
			yourself
		).

]

{ #category : 'directionSymbol' }
WS2DHexGridTopology class >> downLeftSymbol [
	
	^ #down_left
]

{ #category : 'directionSymbol' }
WS2DHexGridTopology class >> downRightSymbol [
	
	^ #down_right
]

{ #category : 'directionSymbol' }
WS2DHexGridTopology class >> downSymbol [
	
	^ #down
]

{ #category : 'directionSymbol' }
WS2DHexGridTopology class >> upLeftSymbol [
	
	^ #up_left
]

{ #category : 'directionSymbol' }
WS2DHexGridTopology class >> upRightSymbol [
	
	^ #up_right
]

{ #category : 'directionSymbol' }
WS2DHexGridTopology class >> upSymbol [
	
	^ #up
]

{ #category : 'matrix' }
WS2DHexGridTopology >> connectEvenColumnNeighborsOf: aNode at: aPoint [
	"Connect to the up-right and down-right neighbour and viceversa"
	
	| i j |
	i := aPoint x.
	j := aPoint y.
	
	self connectIfValid: aNode at: (i @ (j + 1)) inDirection: self class upRightSymbol.
   self connectIfValid: aNode at: ((i + 1) @ (j + 1)) inDirection: self class downRightSymbol.
]

{ #category : 'matrix' }
WS2DHexGridTopology >> connectIfValid: aNode at: aPoint inDirection: aSymbol [

	"Connect aNode to node at aPoint if it is a valid connection"
   (aPoint x between: 1 and: self nRows) ifFalse: [ ^ self ].
   (aPoint y between: 1 and: self nColumns) ifFalse: [ ^ self ].
    
   self connect: aNode to: (self getAtRow: aPoint x andColumn: aPoint y) withDirection: aSymbol
]

{ #category : 'matrix' }
WS2DHexGridTopology >> connectNeighborsOf: aNode at: aPoint [
	
	| i j |
	i := aPoint x.
	j:= aPoint y.
	
	"Connect to the down neighbour and viceversa"
	self connectIfValid: aNode at: ((i + 1) @ j) inDirection: self class downSymbol.
	
	j odd 
		ifTrue:  [ self connectOddColumnNeighborsOf: aNode at: i @ j ]
      	ifFalse: [ self connectEvenColumnNeighborsOf: aNode at: i @ j ].
]

{ #category : 'matrix' }
WS2DHexGridTopology >> connectOddColumnNeighborsOf: aNode at: aPoint [
	"Connect to the up-right and down-right neighbour and viceversa"
	
	| i j |
	i := aPoint x.
	j := aPoint y.
	
	self connectIfValid: aNode at: ((i - 1) @ (j + 1)) inDirection: self class upRightSymbol.
   self connectIfValid: aNode at: (i @ (j + 1)) inDirection: self class downRightSymbol.
]

{ #category : 'tileset' }
WS2DHexGridTopology >> createClassTile: aClass [
	"Create the class tile and returns it"

	| edges |
	
	edges := nil.
	self error.

	(6 - (edges size)) timesRepeat: [edges add: (self class emptyEdgeSymbol)].

	edges := edges collect: [ :each | { each } ].
	
	^ WSClassTile 
		withClass: aClass
		andEdges: (self createTileEdgesFrom: (edges shuffled))
]

{ #category : 'matrix' }
WS2DHexGridTopology >> createEdgesOfNodes [
	"Given a matrix of nodes, assign the edges for each node"
	
	1 to: self nRows do: [ :i |
        1 to: self nColumns do: [ :j |
            self connectNeighborsOf: (self getAtRow: i andColumn: j) at: i @ j
        ]
    ]
]

{ #category : 'tileset' }
WS2DHexGridTopology >> createEmptyTile [
	"Create the empty tile for the rectangular grid topology"
	
	| ees |
	
	ees := self class emptyEdgeSymbol .
	
	^ WSEmptyTile 
		withEdges: 
			(self createTileEdgesFrom: { 
				  	{ ees } . 
					{ ees } . 
					{ ees } . 
					{ ees } . 
					{ ees} . 
				   { ees } }
				  )

]

{ #category : 'tileset' }
WS2DHexGridTopology >> createPathTilesWithID: aSymbol [
	"Given a pathID (a symbol) create the 9 path tiles to connect two classes"

	| emp pth tileSpecs |
    emp := self class emptyEdgeSymbol.
    pth := aSymbol.
    
    tileSpecs := {
        { 1. 50. { {emp}. {pth}. {emp}. {emp}. {pth}. {emp} } }.
        { 2. 50. { {pth}. {emp}. {emp}. {emp}. {emp}. {pth} } }.
        { 3. 50. { {emp}. {emp}. {pth}. {pth}. {emp}. {emp} } }.
        { 4. 25. { {emp}. {pth}. {emp}. {emp}. {emp}. {pth} } }.
        { 5. 25. { {emp}. {emp}. {pth}. {emp}. {pth}. {emp} } }.
        { 6. 25. { {emp}. {emp}. {emp}. {pth}. {emp}. {pth} } }.
        { 7. 25. { {pth}. {emp}. {emp}. {emp}. {pth}. {emp} } }.
        { 8. 25. { {emp}. {pth}. {emp}. {pth}. {emp}. {emp} } }.
        { 9. 25. { {pth}. {emp}. {pth}. {emp}. {emp}. {emp} } }.
    }.

	^ tileSpecs collect: [ :spec |
		WSPathTile 
			withID: spec first
			withWeight: spec second
			withEdges: (self createTileEdgesFrom: (spec last))
			withPathID: aSymbol
   	]
    
]

{ #category : 'tileset' }
WS2DHexGridTopology >> createTileEdgesFrom: anOrderedCollection [
	"For the hex grid topology, it creates the edges for a tile in the order upLeft, up, upRight, downLeft, down, downRight.
	Note that due to how the algorithm works, each position of the OrderedCollection should contain an OrderedCollection, even if it's only one symbol"
	
	^ (Dictionary new
			at: (self class) upLeftSymbol put: (anOrderedCollection first);
			at: (self class) upSymbol put: (anOrderedCollection at: 2) ;
			at: (self class) upRightSymbol put: (anOrderedCollection at: 3);
			at: (self class) downLeftSymbol put: (anOrderedCollection at: 4);
			at: (self class) downSymbol put: (anOrderedCollection at: 5);
			at: (self class) downRightSymbol put: (anOrderedCollection last);
			yourself 
	  ).
]

{ #category : 'initialization' }
WS2DHexGridTopology >> initialize [

	super initialize.
	self visualizer: WS2DisoHexGridVisualizer new
]

{ #category : 'removing' }
WS2DHexGridTopology >> removePossibilitiesFromFirstColumn [

	1 to: self nRows do: [ :i |
			(self getAtRow: i andColumn: 1) keepTilesWithIDin: #( 0 1 4 5 ) 
	].
]

{ #category : 'removing' }
WS2DHexGridTopology >> removePossibilitiesFromFirstRow [

	1 to: self nColumns do: [ :j |
		j odd 
			ifTrue: [ (self getAtRow: 1 andColumn: j) keepTilesWithIDin: #( 0 6 ) ]
			ifFalse: [ (self getAtRow: 1 andColumn: j) keepTilesWithIDin: #( 0 2 3 5 6 7 9 ) ]
	].
]

{ #category : 'removing' }
WS2DHexGridTopology >> removePossibilitiesFromLastColumn [

	1 to: self nRows do: [ :i |
			(self getAtRow: i andColumn: self nColumns) keepTilesWithIDin: #( 0 1 7 8 ) ]
]

{ #category : 'removing' }
WS2DHexGridTopology >> removePossibilitiesFromLastRow [

	1 to: self nColumns do: [ :j |
		j odd 
			ifTrue: [ (self getAtRow: self nRows andColumn: j) keepTilesWithIDin: #( 0 2 3 4 6 8 9 ) ]
			ifFalse: [ (self getAtRow: self nRows andColumn: j) keepTilesWithIDin: #( 0 9 ) ] 
	].
]
