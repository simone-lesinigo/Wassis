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

{ #category : 'as yet unclassified' }
WSTileset >> tileForDirections: dirToPathID [
	"Return the tile each edge contains the pathID in dirToPathID"

	| pathIDs candidates |
	pathIDs := Set new.
	candidates := OrderedCollection new.
	pathIDs addAll: (dirToPathID select: [ :eachValue | eachValue ~= '00' asSymbol ]).
	
	pathIDs do: [ :eachPathID | candidates addAll: (self pathTiles at: eachPathID) ].
	
	^ candidates detect: [ :eachTile |
	    dirToPathID associations allSatisfy: [ :assoc |
	        (eachTile edges at: assoc key) includes: assoc value ] ]
	

]

{ #category : 'adding' }
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
