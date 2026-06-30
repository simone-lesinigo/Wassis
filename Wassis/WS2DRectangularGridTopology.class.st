"
It creates the graph for a rectangular grid. You can set the dimension with a point (ex: 10 @ 5)
"
Class {
	#name : 'WS2DRectangularGridTopology',
	#superclass : 'WS2DGridTopology',
	#instVars : [
		'emptyTile'
	],
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

{ #category : 'accessing' }
WS2DRectangularGridTopology class >> horizontalSymbols [
	
	^ OrderedCollection 
		with: self leftSymbol 
		with: self rightSymbol
]

{ #category : 'directionSymbol' }
WS2DRectangularGridTopology class >> leftSymbol [
	
	^ #left
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
WS2DRectangularGridTopology class >> verticalSymbols [
	
	^ OrderedCollection 
		with: self upSymbol 
		with: self downSymbol
]

{ #category : 'converting' }
WS2DRectangularGridTopology >> asFailedExecution [
	
	^ WS2DRectangularGridFailedExecution
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> assignConnections: connectionDirections toSlots: slots forClass: aClass [
	"Return a dictionary WSNode -> aDictionary where aDictionary is direction -> pathID. Select the right strategy"
	
	| strategySelector |
	
	strategySelector := ('assignConnections' , WSConfig connectionAssignmentStrategy , ':toSlots:forClass:') asSymbol.
	
	^ self perform: strategySelector withArguments: { connectionDirections . slots . aClass }.
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> assignConnectionsGreedy: connectionDirections toSlots: slots forClass: aClass [
	"Return a dictionary WSNode -> aDictionary where aDictionary is direction -> pathID. Greedy strategy based on the first available slot"
 	
	| nodeEdges |

    nodeEdges := Dictionary new.
    slots do: [ :nodes | nodes do: [ :aNode | nodeEdges at: aNode ifAbsentPut: [ Dictionary new ] ] ].

	connectionDirections do: [ :eachAssign | 
		| bestDir  availableNodes bestNode |
		bestDir := eachAssign directionCosts detect: [ :eachCostAssoc | 
			(slots at: eachCostAssoc key ifAbsent: [ #() ]) isNotEmpty ] ifNone: [ nil ].
		
		bestDir ifNotNil: [  
			| bestDirSymbol secondaryDirSymbol |
			bestDirSymbol := bestDir key.
			secondaryDirSymbol := (eachAssign directionCosts detect: [ :eachAssoc | eachAssoc key ~= bestDirSymbol ]) key.
			availableNodes := slots at: bestDirSymbol.
			bestNode := self bestNodeFrom: availableNodes alignedWith: secondaryDirSymbol.
			nodeEdges at: bestNode at: bestDirSymbol put: eachAssign pathID.
			availableNodes remove: bestNode
		]
	].
    
    ^ nodeEdges

]

{ #category : 'directions' }
WS2DRectangularGridTopology >> assignConnectionsGrouped: connectionDirections toSlots: slots forClass: aClass [
    "Return a dictionary WSNode -> aDictionary where aDictionary is direction -> pathID. Group the pathIDs by preferred direction and try to assign the best slot globally"

    | nodeEdges remaining |
    nodeEdges := Dictionary new.
    slots do: [ :nodes | nodes do: [ :aNode | nodeEdges at: aNode ifAbsentPut: [ Dictionary new ] ] ].

    remaining := self
        assignGrouped: connectionDirections
        toSlots: slots
        into: nodeEdges.

    [ remaining isNotEmpty ] whileTrue: [
        remaining do: [ :each | each degrade ].
        remaining := self
            assignGrouped: remaining
            toSlots: slots
            into: nodeEdges.
    ].

    ^ nodeEdges
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> assignGrouped: assignments toSlots: slots into: nodeEdges [
    "Assign each assignment to its preferred slot direction.
     Returns an OrderedCollection of assignments that couldn't be placed."

    | grouped overflow |
    overflow := OrderedCollection new.
    grouped := Dictionary new.

    assignments do: [ :each |
        (grouped
            at: each targetDir key
            ifAbsentPut: [ SortedCollection sortBlock: [ :a :b | a targetDir value <= b targetDir value ] ])
            add: each ].

    grouped keysAndValuesDo: [ :dir :dirAssignments |
        | available winners losers dirAssignmentsColl |
        available := (slots at: dir ifAbsent: [ #() ]) size.
		  dirAssignmentsColl := dirAssignments asOrderedCollection.
        dirAssignmentsColl size <= available
            ifTrue: [
                winners := dirAssignments asOrderedCollection.
                losers := #() ]
            ifFalse: [
                winners := dirAssignmentsColl copyFrom: 1 to: available.
                losers := dirAssignmentsColl copyFrom: available + 1 to: dirAssignmentsColl size ].
        self assignPathIDs: winners toSlots: (slots at: dir ifAbsent: [ #() ]) into: nodeEdges.
        overflow addAll: losers ].

    ^ overflow
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> assignPathIDs: assignments toSlots: slots into: nodeEdges [
	
	| sortedByAlignment |
	sortedByAlignment := (SortedCollection sortBlock: [ :a :b |  a alignmentDir value <= b alignmentDir value]) addAll: assignments; yourself.

	sortedByAlignment do: [ :eachAssign |
  		| bestNode |
      bestNode := self bestNodeFrom: slots alignedWith: eachAssign alignmentDir key.
      nodeEdges at: bestNode at: eachAssign targetDir key put: eachAssign pathID.
      slots remove: bestNode ].
	
	
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> bestNodeFrom: nodes alignedWith: alignmentDir [
	"Between the nodes that expose all the same direction, find the one that best fit alignmentDir"

    nodes size = 1 ifTrue: [ ^ nodes first ].
    alignmentDir = self class leftSymbol  ifTrue: [ ^ nodes detectMin: [ :n | n column ] ].
    alignmentDir = self class rightSymbol ifTrue: [ ^ nodes detectMax: [ :n | n column ] ].
    alignmentDir = self class upSymbol    ifTrue: [ ^ nodes detectMin: [ :n | n row ] ].
    alignmentDir = self class downSymbol  ifTrue: [ ^ nodes detectMax: [ :n | n row ] ].

    ^ nodes first
]

{ #category : 'deprecated-directions' }
WS2DRectangularGridTopology >> bestSlotForDirection: bestDir secondaryDir: secondaryDir fromSlots: slots [
    "Among all slots with bestDir, pick the one whose node is most aligned 
     with secondaryDir"
    
    | candidates |
    candidates := slots select: [ :s | s value = bestDir ].
    candidates size = 1 ifTrue: [ ^ candidates first ].
    
    "Sort candidates by secondary direction"
    secondaryDir = self class leftSymbol  ifTrue: [ ^ candidates detectMin: [ :s | s key column ] ].
    secondaryDir = self class rightSymbol ifTrue: [ ^ candidates detectMax: [ :s | s key column ] ].
    secondaryDir = self class upSymbol    ifTrue: [ ^ candidates detectMin: [ :s | s key row ] ].
    secondaryDir = self class downSymbol  ifTrue: [ ^ candidates detectMax: [ :s | s key row ] ].
    
    ^ candidates first
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> buildAvailableSlotsFor: aFootprint [
    "Returns a Dictionary of (direction -> WSNode) for all exposed directions"
    
    | slots |
    slots := Dictionary new.
    aFootprint nodes do: [ :aNode |
			| exposedDir |
			exposedDir := (self exposedDirectionsOf: aNode inFootprint: aFootprint ).
			exposedDir do: [ :eachDir | (slots at: eachDir ifAbsentPut: [ OrderedCollection new ]) add: aNode]
    ].

    ^ slots
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> buildTileSpecs [
	"Build the specification of the path tiles"
	
	| empty straightTileWeight cornerTileWeight mergingTileWeight crossingTileWeight tileSpecs firstPathSymbol secondPathSymbol |
	empty := WSConfig emptyEdgeSymbol.
	firstPathSymbol :=  WSConfig firstPathSymbol.
	secondPathSymbol := WSConfig secondPathSymbol.
   straightTileWeight := WS2DRectangularGridConfig straightTileWeight.
   cornerTileWeight := WS2DRectangularGridConfig cornerTileWeight.
	mergingTileWeight := WS2DRectangularGridConfig mergingTileWeight.
	crossingTileWeight := WS2DRectangularGridConfig crossingTileWeight.
	
	tileSpecs := {
        { 1.  straightTileWeight . { empty. firstPathSymbol. firstPathSymbol. empty } . { firstPathSymbol } }.
        { 2.  straightTileWeight . { firstPathSymbol. empty. empty. firstPathSymbol  } . { firstPathSymbol } }.
        { 3.  cornerTileWeight   . { firstPathSymbol. empty. firstPathSymbol. empty  } . { firstPathSymbol } }.
        { 4.  cornerTileWeight   . { firstPathSymbol. firstPathSymbol. empty. empty  } . { firstPathSymbol } }.
        { 5.  cornerTileWeight   . { empty. empty. firstPathSymbol. firstPathSymbol  } . { firstPathSymbol } }.
        { 6.  cornerTileWeight   . { empty. firstPathSymbol. empty. firstPathSymbol  } . { firstPathSymbol } }.
        { 7.  mergingTileWeight  . { firstPathSymbol. firstPathSymbol. empty. firstPathSymbol } . { firstPathSymbol } }.
        { 8.  mergingTileWeight  . { firstPathSymbol. empty. firstPathSymbol. firstPathSymbol } . { firstPathSymbol } }.
        { 9.  mergingTileWeight  . { firstPathSymbol. firstPathSymbol. firstPathSymbol. empty } . { firstPathSymbol } }.
        { 10. mergingTileWeight  . { empty. firstPathSymbol. firstPathSymbol. firstPathSymbol } . { firstPathSymbol } }.
        { 11. mergingTileWeight  . { firstPathSymbol. firstPathSymbol. firstPathSymbol. firstPathSymbol } . { firstPathSymbol } }.
		  { 12. crossingTileWeight. { secondPathSymbol. firstPathSymbol.  firstPathSymbol.  secondPathSymbol }. { firstPathSymbol. secondPathSymbol } }.
		  { 13. crossingTileWeight. { firstPathSymbol.   secondPathSymbol. firstPathSymbol. secondPathSymbol }. { firstPathSymbol. secondPathSymbol } }.
		  { 14. crossingTileWeight. { firstPathSymbol.   firstPathSymbol. secondPathSymbol. secondPathSymbol }. { firstPathSymbol. secondPathSymbol } } .
    } asOrderedCollection.

	^ tileSpecs 
	

]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> buildTileSpecsForPathID: aPathID [
	"Build the specification of the path tiles for a certain ID"
	
	| empty straightTileWeight cornerTileWeight mergingTileWeight crossingTileWeight tileSpecs |
	empty := WSConfig emptyEdgeSymbol.
   straightTileWeight := WS2DRectangularGridConfig straightTileWeight.
   cornerTileWeight := WS2DRectangularGridConfig cornerTileWeight.
	mergingTileWeight := WS2DRectangularGridConfig mergingTileWeight.
	crossingTileWeight := WS2DRectangularGridConfig crossingTileWeight.
	
	tileSpecs := {
        { 1.  straightTileWeight . { empty. aPathID. aPathID. empty } . { aPathID } }.
        { 2.  straightTileWeight . { aPathID. empty. empty. aPathID  } . { aPathID } }.
        { 3.  cornerTileWeight   . { aPathID. empty. aPathID. empty  } . { aPathID } }.
        { 4.  cornerTileWeight   . { aPathID. aPathID. empty. empty  } . { aPathID } }.
        { 5.  cornerTileWeight   . { empty. empty. aPathID. aPathID  } . { aPathID } }.
        { 6.  cornerTileWeight   . { empty. aPathID. empty. aPathID  } . { aPathID } }.
        { 7.  mergingTileWeight  . { aPathID. aPathID. empty. aPathID } . { aPathID } }.
        { 8.  mergingTileWeight  . { aPathID. empty. aPathID. aPathID } . { aPathID } }.
        { 9.  mergingTileWeight  . { aPathID. aPathID. aPathID. empty } . { aPathID } }.
        { 10. mergingTileWeight  . { empty. aPathID. aPathID. aPathID } . { aPathID } }.
        { 11. mergingTileWeight  . { aPathID. aPathID. aPathID. aPathID } . { aPathID } }.
    } asOrderedCollection.

(self swSystem allPathIDs 
    select: [ :eachPathID | eachPathID ~= aPathID ])
    do: [ :eachPathID |
        tileSpecs add: { 12. crossingTileWeight. { eachPathID. aPathID.  aPathID.  eachPathID }. { aPathID. eachPathID } }.
        tileSpecs add: { 13. crossingTileWeight. { aPathID.   eachPathID. aPathID. eachPathID }. { aPathID. eachPathID } }.
        tileSpecs add: { 14. crossingTileWeight. { aPathID.   aPathID. eachPathID. eachPathID }. { aPathID. eachPathID } } ].

	^ tileSpecs 
	

]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> buildTiles: nodeEdges forClass: aClass [
    "Returns a Dictionary WSNode -> WSClassTile"
    
    | result ees posDir |
    result := Dictionary new.
    ees := WSConfig emptyEdgeSymbol.
    posDir := self class positionDirection.

    nodeEdges keysAndValuesDo: [ :aNode :dirPathDict |
        | edges |
        edges := OrderedCollection new: 4 withAll: ees.
        dirPathDict keysAndValuesDo: [ :dir :pathID |
            edges at: (posDir at: dir) put: pathID ].
        result at: aNode put: (WSClassTile withClass: aClass andEdges: (self createTileEdgesFrom: edges)) ].

    ^ result
]

{ #category : 'metrics' }
WS2DRectangularGridTopology >> calculateDistancesBetweenClasses [
	"Calculate the Manhattan distance between all the classes that are connected"

	| dict |
	dict := Dictionary new.
	
	self classFootprint keysAndValuesDo: [ :eachClass :eachFootprint |
		eachClass getConnectedWithClasses do: [ :eachConnectedClass |
			| connectedClassFootprint distance |
			connectedClassFootprint := (self classFootprint at: eachConnectedClass).
			distance := (self 
								manhattanDistanceBetweenFootprint: eachFootprint 
								andFootprint: connectedClassFootprint).
			dict 
				at:(eachClass -> eachConnectedClass) 
				put: (distance isZero ifTrue: [ 0 ] ifFalse: [ distance - 1 ])
		]
	].

	^ dict
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> centroidNodeForClasses: aCollectionOfClasses [
	"Computes the average position (centroid) of a collection of classes"

	| sumPoint count |
	count := aCollectionOfClasses size.
	
	sumPoint := aCollectionOfClasses 
		inject: 0 @ 0
		into: [ :acc :eachClass | 
			| node |
			node := (self classFootprint at: eachClass) centerNode.
			acc + (node row @ node column) ].

	^ WSNode new position: { (sumPoint x / count) . (sumPoint y / count) }
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> computeConnectionDirectionsFor: aClass withFootprint: aFootprint [
	"Returns a Dictionary, keys are all the IDs that a class must have, values the preferred directions for each id"

	| pathIDToClasses connectionDirections sourceCenter |
	connectionDirections := OrderedCollection new.
	sourceCenter := aFootprint centerNode.
	pathIDToClasses := Dictionary new.
	
	(self swSystem allConnectionsOf: aClass) do: [ :eachConnectedClass |
			(self swSystem pathIDsOf: aClass and: eachConnectedClass) do: [ :pathID |
				(pathIDToClasses at: pathID ifAbsentPut: [ OrderedCollection new ]) add: eachConnectedClass ] ].
		
	^ pathIDToClasses associations collect: [ :eachAssociation |
		| pathID classes centroidNode directions |
		pathID := eachAssociation key.
		classes := eachAssociation value.
		
		centroidNode := self centroidNodeForClasses: classes.
		directions := self preferredDirectionsFrom: sourceCenter to: centroidNode.
		
		WSPathAssignment withPathID: pathID withDirectionCosts: directions ]
]

{ #category : 'deprecated-directions' }
WS2DRectangularGridTopology >> computeDirectionsFor2: deltaX and: deltaY [
	"Returns an OrderedCollection of directions sorted by preference"
	| preferred remaining |
	
	preferred := (self primaryDirectionsFor: deltaX and: deltaY) asOrderedCollection.
	preferred size = 2 ifTrue: [ preferred add: (self oppositeDirections at: preferred second) ].
	
	remaining := self class allSymbols asOrderedCollection.
	remaining removeAll: preferred. 
	
	^ preferred , (remaining shuffled)
]

{ #category : 'directions' }
WS2DRectangularGridTopology >> computeDirectionsFor: deltaX and: deltaY [
	"Returns an OrderedCollection of directions. At each direction is assigned a value based on the cosine similarity. 0 = perfect, 1 = orthogonal, 2 = opposite. Note: despite the classes have a minimum distance between them, due to the calculation of the centroid bot deltaX and deltaY cna be 0 at the same time -> no preferred direction"

    | norm costFor directions |
	 (deltaX = 0 and: [ deltaY = 0 ]) ifTrue: [ 
	    ^ (OrderedCollection new
	        add: self class rightSymbol -> 1.0;
	        add: self class leftSymbol  -> 1.0;
	        add: self class downSymbol  -> 1.0;
	        add: self class upSymbol    -> 1.0;
	        yourself) shuffled ].

    norm := ((deltaX * deltaX) + (deltaY * deltaY)) sqrt.
    costFor := [ :vx :vy | 1.0 - (((deltaX * vx) + (deltaY * vy)) / norm) ].

	 directions := OrderedCollection new
        add: self class rightSymbol -> (costFor value:  1 value:  0);
        add: self class leftSymbol  -> (costFor value: -1 value:  0);
        add: self class downSymbol  -> (costFor value:  0 value:  1);
        add: self class upSymbol    -> (costFor value:  0 value: -1);
        yourself.

    ^ directions sorted: [ :a :b | a value <= b value ]
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createAllPathTiles [
	"Create all the necessary path tiles for all entities and returns them"

	| pathTiles tileSpecs |
	
	pathTiles := OrderedCollection new.
   
    tileSpecs := self buildTileSpecs.
    
	 pathTiles := (tileSpecs collect: [ :spec |
		WSPathTile 
			withID: spec first
			withWeight: spec second
			withEdges: (self createTileEdgesFrom: (spec third))
			withPathIDs: spec fourth
     ]).

	self tileset pathTiles at: WSConfig firstPathSymbol put: pathTiles. 
	self tileset pathTiles at: WSConfig secondPathSymbol put: pathTiles. 

	^ pathTiles 
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createClassTiles: aClass forFootprint: aFootprint [
    "Returns a Dictionary WSNode -> WSClassTile with exits distributed across the footprint"

    | connectionDirections slots nodes |

    connectionDirections := (self computeConnectionDirectionsFor: aClass withFootprint: aFootprint).

	 slots := self buildAvailableSlotsFor: aFootprint.
	
	 "Add border nodes"
	 nodes := self assignConnections: connectionDirections toSlots: slots forClass: aClass.

	 "Add inner nodes"
	 (aFootprint innerNodes: self) do: [ :eachNode | 
		nodes at: eachNode put: Dictionary new
	 ].

    ^ self buildTiles: nodes forClass: aClass.
]

{ #category : 'matrix' }
WS2DRectangularGridTopology >> createEdgesIn: aGrid [
"Given a WSGrid2D, assign the edges for each node using the topology's rules"
	
	1 to: aGrid nRows do: [ :i |
		1 to: aGrid nColumns do: [ :j |
			| eachNode | 
			eachNode := aGrid atRow: i atColumn: j.
			
			"Connect to the right neighbour and viceversa"
			j < aGrid nColumns ifTrue: [ 
				self connect: eachNode 
					  to: (aGrid atRow: i atColumn: (j + 1)) 
					  withDirection: self class rightSymbol
			].
			
			"Connect to the down neighbour and viceversa"
			i < aGrid nRows ifTrue: [ 
				self connect: eachNode 
					  to: (aGrid atRow: (i + 1) atColumn: j)
					  withDirection: self class downSymbol 
			]
		]
	]
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createEmptyTile [
	"Create the empty tile for the rectangular grid topology"
	
	| emptyEdgeSymbol |
	
	emptyEdgeSymbol := WSConfig emptyEdgeSymbol.
	
	^ WSEmptyTile withEdges: 
		(self createTileEdgesFrom: { 
			emptyEdgeSymbol . 
			emptyEdgeSymbol .
			emptyEdgeSymbol .
			emptyEdgeSymbol }
		 )
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createErrorTile [
	
	^ WSErrorTile new
		id: -1;
		weight: 0;
		edges: (self createTileEdgesFrom: (OrderedCollection new: 4 withAll: nil))
		
		
	
]

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createPathTilesWithID: aSymbol [
    "Given a pathID (a symbol) create the path tiles to connect two classes"

    | tileSpecs pathTiles |
   
    tileSpecs := self buildTileSpecsForPathID: aSymbol.
    
	 pathTiles := (tileSpecs collect: [ :spec |
		WSPathTile 
			withID: spec first
			withWeight: spec second
			withEdges: (self createTileEdgesFrom: (spec third))
			withPathIDs: spec fourth
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

{ #category : 'tileset' }
WS2DRectangularGridTopology >> createUncollapsedTile [
	
	^ WSUncollapsedTile new
		id: -1;
		weight: 0;
		edges: (self createTileEdgesFrom: (OrderedCollection new: 4 withAll: nil))
		
		
	
]

{ #category : 'visualization' }
WS2DRectangularGridTopology >> createVisualizationFor: adaptiveSolver [

	| presenter canvas |
	presenter := WSResultPresenter withAdaptiveSolver: adaptiveSolver.
	canvas := self visualizer createCanvasFor: adaptiveSolver solver.
	presenter setCanvas: canvas; open. 
	
]

{ #category : 'visualization' }
WS2DRectangularGridTopology >> createVisualizationForSolver: solver [

	| presenter canvas |
	presenter := WSResultPresenter new.
	canvas := self visualizer createCanvasFor: solver.
	presenter setCanvas: canvas; open. 
	
]

{ #category : 'metrics' }
WS2DRectangularGridTopology >> distanceBetweenNode: aNode1 toNode: aNode2 [
	
	^ self manhattanDistanceBetweenNode: aNode1 andNode: aNode2
]

{ #category : 'accessing' }
WS2DRectangularGridTopology >> emptyTile [

	emptyTile ifNil: [ self emptyTile: self createEmptyTile ].
	
	^ emptyTile 
]

{ #category : 'accessing' }
WS2DRectangularGridTopology >> emptyTile: anObject [

	emptyTile := anObject
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

{ #category : 'collapse' }
WS2DRectangularGridTopology >> exposedDirectionsOf: aNode inFootprint: aFootprint [
    "Return the directions of aNode that face outside the footprint"
    
    | originRow originColumn exposed |
    originRow := aFootprint originNode row. 
    originColumn := aFootprint originNode column.
    exposed := OrderedCollection new.
    
    aNode row = originRow ifTrue: [ exposed add: self class upSymbol ].
    aNode row = (originRow + aFootprint sideLength - 1) ifTrue: [ exposed add: self class downSymbol  ].
    aNode column = originColumn ifTrue: [ exposed add: self class leftSymbol ].
    aNode column = (originColumn + aFootprint sideLength - 1) ifTrue: [ exposed add: self class rightSymbol ].
    
    ^ exposed
]

{ #category : 'initialization' }
WS2DRectangularGridTopology >> initialize [

	super initialize.
	self visualizer:WS2DRectangularGridVisualizer new
]

{ #category : 'metrics' }
WS2DRectangularGridTopology >> manhattanDistanceBetweenFootprint: footprint1 andFootprint: footprint2 [
	"Caluclates the manhattan distance between two footprints"

	| minDistance |
	minDistance := SmallInteger maxVal.

	(footprint1 borderNodes: self) do: [ :eachBorderNodes1 |
			(footprint2 borderNodes: self) do: [ :eachBorderNodes2 |
					| currentDistance |
					currentDistance := self 
						manhattanDistanceBetweenNode: eachBorderNodes1 
						andNode: eachBorderNodes2.		
											
					minDistance := (minDistance min: currentDistance).
					
					minDistance <= WS2DGridConfig gridSafetyMooreRadius ifTrue: [ ^ minDistance ]
			] ].
			
	^ minDistance 
]

{ #category : 'metrics' }
WS2DRectangularGridTopology >> manhattanDistanceBetweenNode: node1 andNode: node2 [
	"Calculate the manhattan distance between two nodes"
	
	 ^ ((node1 position first - node2 position first) abs) + 
      ((node1 position second - node2 position second) abs).
    

]

{ #category : 'directions' }
WS2DRectangularGridTopology >> preferredDirectionsFrom: sourceNode to: targetNode [
	"Create a list of associations (up -> weight, left -> weight, right -> weight, down -> weight), the order of the directions is given by a preferred choice based on the relative position of the target compared with the position of the source"
	
    | deltaX deltaY |
    deltaX := targetNode column - sourceNode column.
    deltaY := targetNode row - sourceNode row.

    ^ self computeDirectionsFor: deltaX and: deltaY
	
	
]

{ #category : 'deprecated-directions' }
WS2DRectangularGridTopology >> primaryDirectionsFor: deltaX and: deltaY [
	"Note that deltaX can be equal to deltaY but they cannot be both 0 at the same time"
	
	| horizontal vertical |
	horizontal := deltaX >= 0 ifTrue: [ self class rightSymbol ] ifFalse: [ self class leftSymbol ].
	vertical := deltaY >= 0 ifTrue: [ self class downSymbol ] ifFalse: [ self class upSymbol ].

	"Target on diagonal"
	deltaX abs = deltaY abs ifTrue: [ ^ { horizontal. vertical } shuffled ].

	"Target on horizontal line"
	deltaY = 0 ifTrue: [ ^ { horizontal } , (self class verticalSymbols shuffled) ].

	"Target on vertical line"
	deltaX = 0 ifTrue: [ ^ { vertical } , (self class horizontalSymbols shuffled) ].

	^ deltaX abs > deltaY abs 
		ifTrue: [ { horizontal  } ] 
		ifFalse: [ { vertical . horizontal } ]
]

{ #category : 'reification' }
WS2DRectangularGridTopology >> rebuildClassNodes: aGraph [
	
	| classNodesDict |
	classNodesDict := Dictionary new.
	aGraph nodes do: [ :eachNode |
		eachNode isClassNode ifTrue: [
	   		| footprint |			
	       footprint := classNodesDict 
	                at: eachNode tileInWhichCollapsed wsClass 
	                ifAbsentPut: [ eachNode footPrint ].
	        ]
	].
	self classFootprint: classNodesDict
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromFirstColumnIn: aGrid [

	aGrid firstColumnDo: [ :node | node keepTilesWithIDin: #( 0 2 3 5 ) ].
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromFirstRowIn: aGrid [

	aGrid firstRowDo: [ :node | node keepTilesWithIDin: #( 0 1 5 6 ) ].
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromLastColumnIn: aGrid [

	aGrid lastColumnDo: [ :node | node keepTilesWithIDin: #( 0 2 4 6 ) ].
]

{ #category : 'removing' }
WS2DRectangularGridTopology >> removePossibilitiesFromLastRowIn: aGrid [

	aGrid lastRowDo: [ :node | node keepTilesWithIDin: #( 0 1 3 4 ) ].
]

{ #category : 'collapse' }
WS2DRectangularGridTopology >> selectBestCandidate: candidates forClass: aClass footprintSize: n in: aGrid [
	"Among the candidates for class positioning, select the one that minimize the manhattan distance form all the classes it is connected to that have already been placed"
	
	 | connectedFootprints |
	 connectedFootprints := OrderedCollection new.
	 (self swSystem allConnectionsOf: aClass) do: [ :eachConnection | 
		self classFootprint at: eachConnection ifPresent: [ :each | connectedFootprints add: each ].
	 ].

    connectedFootprints ifEmpty: [ ^ candidates atRandom ].

	^ candidates detectMin: [ :eachCandidate |
		| fakeFootprint totalDist |
		fakeFootprint := WSFootprint new
      		nodes: (aGrid collectFootprintFrom: eachCandidate size: n);
         originNode: eachCandidate;
         sideLength: n;
         yourself.
		
		totalDist := connectedFootprints inject: 0 into: [ :sum :fp | 
			sum + (self manhattanDistanceBetweenFootprint: fakeFootprint andFootprint: fp).
		]
	]
]
