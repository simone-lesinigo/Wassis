"
Represents the tileset, the set with all the possible tiles.
"
Class {
	#name : 'WSTileset',
	#superclass : 'WSObject',
	#instVars : [
		'tiles',
		'pathTiles'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'adding' }
WSTileset >> addTile: aTile [
	"Add a tile to the tileset"

	self tiles add: aTile
]

{ #category : 'adding' }
WSTileset >> addTiles: aTilesArray [
	"Add tiles to the tileset"

	self tiles addAll: aTilesArray
]

{ #category : 'finding' }
WSTileset >> createTileForDirections: dirToPathID pathIDs: pathIDsSet [

    | edges tile matchingSpec abstractPattern pathIDsList translationMap |
    edges := Dictionary new.
    dirToPathID keysAndValuesDo: [ :dir :sym |
        edges at: dir put: (OrderedCollection with: sym) ].

    pathIDsList := pathIDsSet asArray.
    translationMap := Dictionary new.
    pathIDsList isNotEmpty ifTrue: [ translationMap at: (pathIDsList first) put: WSConfig firstPathSymbol ].
    pathIDsList size >= 2 ifTrue: [ translationMap at: (pathIDsList at: 2) put: WSConfig secondPathSymbol ].
    translationMap at: WSConfig emptyEdgeSymbol put: WSConfig emptyEdgeSymbol.

    abstractPattern := { #up . #left . #right . #down } collect: [ :dir | | realSym |
        realSym := dirToPathID at: dir ifAbsent: [ WSConfig emptyEdgeSymbol ].
        translationMap at: realSym ].

    matchingSpec := WS2DRectangularGridTopology new buildTileSpecs 
        detect: [ :spec | spec third = abstractPattern ]
        ifNone: [ self error: 'Geometria non trovata nelle tileSpecs!' ].

    tile := WSPathTile
        withID: matchingSpec first
        withWeight: matchingSpec second
        withEdges: edges
        withPathIDs: pathIDsSet asOrderedCollection.

    pathIDsSet do: [ :pid |
        (self pathTiles at: pid ifAbsentPut: [ Set new ]) add: tile ].
        
    ^ tile
]

{ #category : 'initialization' }
WSTileset >> initialize [ 
	super initialize.
	self tiles: OrderedCollection new.
	self pathTiles: Dictionary new.
]

{ #category : 'accessing' }
WSTileset >> pathTiles [

	^ pathTiles
]

{ #category : 'accessing' }
WSTileset >> pathTiles: anObject [

	pathTiles := anObject
]

{ #category : 'finding' }
WSTileset >> tileForDirections: dirToPathID [
	"Return the tile each edge contains the pathID in dirToPathID"

	| pathIDs candidates |
	pathIDs := Set new.
	candidates := OrderedCollection new.
	
	pathIDs addAll: (dirToPathID select: [ :eachValue | eachValue ~= WSConfig emptyEdgeSymbol ]).
	
	pathIDs flattened do: [ :eachPathID | candidates addAll: (self pathTiles at: eachPathID) ].

    ^ (candidates detect: [ :eachTile |
        dirToPathID associations allSatisfy: [ :assoc |
            (eachTile edges at: assoc key) includes: assoc value ] ]
       ifNone: [ self createTileForDirections: dirToPathID pathIDs: pathIDs  ])
	

]

{ #category : 'deprecated' }
WSTileset >> tileForDirections: directions pathID: pathID [
	"Return the tile in which each direction in directions contain pathID"
    | tile |
		
    tile := self pathTiles at: pathID.
    
    ^ tile detect: [ :eachTile | 
        directions allSatisfy: [ :eachDir | 
            (eachTile edges at: eachDir) includes: pathID ] ]
]

{ #category : 'accessing' }
WSTileset >> tiles [

	^ tiles
]

{ #category : 'accessing' }
WSTileset >> tiles: anObject [

	tiles := anObject
]
