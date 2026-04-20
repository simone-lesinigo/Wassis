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

{ #category : 'adding' }
WSTileset >> tileForDirections: directions pathID: pathID [
	"Return the tile in which each direction in directions contain pathID"
	<toDO> "Remove the directions = 4 control as the + tile should be in the tileset"
    | tile |

directions size = 4 ifTrue: [ 
		^ WSPathTile new 
			id: 11;
			weight: 1;
			pathID: pathID;
			edges: (Dictionary new
				at: #up put: (OrderedCollection with: pathID asSymbol);
				at: #down put: (OrderedCollection with: pathID asSymbol);
				at: #left put: (OrderedCollection with: pathID asSymbol);
				at: #right put: (OrderedCollection with: pathID asSymbol);
				yourself);
			yourself ].
		
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
