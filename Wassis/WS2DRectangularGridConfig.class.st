"
Config for a 2D rectangular grid
"
Class {
	#name : 'WS2DRectangularGridConfig',
	#superclass : 'WS2DGridConfig',
	#classVars : [
		'CornerTileWeight',
		'CrossingTileWeight',
		'EmptyTileWeight',
		'MergingTileWeight',
		'SquareVisitorTileSize',
		'StraightTileWeight'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WS2DRectangularGridConfig class >> cornerTileWeight [
	
	CornerTileWeight ifNil: [ 
		self cornerTileWeight: 
			(self configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'corner'} default: 25).
	].

	^ CornerTileWeight
]

{ #category : 'private - accessing' }
WS2DRectangularGridConfig class >> cornerTileWeight: anObject [

	CornerTileWeight := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridConfig class >> crossingTileWeight [
	
	CrossingTileWeight ifNil: [ 
		self crossingTileWeight: 
			(self configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'crossing'} default: 0).
	].

	^ CrossingTileWeight
]

{ #category : 'private - accessing' }
WS2DRectangularGridConfig class >> crossingTileWeight: anObject [

	CrossingTileWeight := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridConfig class >> emptyTileWeight [
	
	EmptyTileWeight ifNil: [ 
		self emptyTileWeight: 
			(self configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'empty'} default: 4000).
	].

	^ EmptyTileWeight
]

{ #category : 'private - accessing' }
WS2DRectangularGridConfig class >> emptyTileWeight: anObject [

	EmptyTileWeight := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridConfig class >> mergingTileWeight [
	
	MergingTileWeight ifNil: [  
		 self mergingTileWeight: 
			(self configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'merging'} default: 0).
	].

	^ MergingTileWeight
]

{ #category : 'private - accessing' }
WS2DRectangularGridConfig class >> mergingTileWeight: anObject [

	MergingTileWeight := anObject
]

{ #category : 'class initialization' }
WS2DRectangularGridConfig class >> reset [

	self emptyTileWeight: nil. 
	self cornerTileWeight: nil. 
	self straightTileWeight: nil. 
	self crossingTileWeight: nil. 
	self mergingTileWeight: nil. 
	
	self squareVisitorTileSize: nil. 
]

{ #category : 'accessing' }
WS2DRectangularGridConfig class >> squareVisitorTileSize [
	
	SquareVisitorTileSize ifNil: [  
		self squareVisitorTileSize: 
			(self configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'squareVisitorTileSize'} default: 50).
	].

	^ SquareVisitorTileSize
]

{ #category : 'private - accessing' }
WS2DRectangularGridConfig class >> squareVisitorTileSize: anObject [

	SquareVisitorTileSize := anObject
]

{ #category : 'accessing' }
WS2DRectangularGridConfig class >> straightTileWeight [
	
	StraightTileWeight ifNil: [  
		 self straightTileWeight: (
			self configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'straight'} default: 50).
	].

	^ StraightTileWeight
]

{ #category : 'private - accessing' }
WS2DRectangularGridConfig class >> straightTileWeight: anObject [

	StraightTileWeight := anObject
]
