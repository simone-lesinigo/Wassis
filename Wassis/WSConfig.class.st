"
Config of all the parameters of the algorithm
"
Class {
	#name : 'WSConfig',
	#superclass : 'WSObject',
	#classInstVars : [
		'uniqueInstance',
		'configFile',
		'maxNumberOfTriesPerGraph',
		'maxNumberOfRegeneratedGraph',
		'gridSafetyMooreRadius',
		'squareVisitorTileSize',
		'emptyTileWeight',
		'cornerTileWeight',
		'straightTileWeight',
		'crossingTileWeight',
		'mergingTileWeight'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WSConfig class >> configFile [

	^ configFile
]

{ #category : 'private' }
WSConfig class >> configFile: anObject [

	configFile := anObject
]

{ #category : 'accessing' }
WSConfig class >> cornerTileWeight [

	^ cornerTileWeight
]

{ #category : 'private' }
WSConfig class >> cornerTileWeight: anObject [

	cornerTileWeight := anObject
]

{ #category : 'accessing' }
WSConfig class >> crossingTileWeight [

	^ crossingTileWeight
]

{ #category : 'private' }
WSConfig class >> crossingTileWeight: anObject [

	crossingTileWeight := anObject
]

{ #category : 'accessing' }
WSConfig class >> emptyTileWeight [

	^ emptyTileWeight
]

{ #category : 'private' }
WSConfig class >> emptyTileWeight: anObject [

	emptyTileWeight := anObject
]

{ #category : 'accessing' }
WSConfig class >> gridSafetyMooreRadius [

	^ gridSafetyMooreRadius
]

{ #category : 'private' }
WSConfig class >> gridSafetyMooreRadius: anObject [

	gridSafetyMooreRadius := anObject
]

{ #category : 'class initialization' }
WSConfig class >> initialize [ 
	
	self readConfigFile.
	self loadDefaults
]

{ #category : 'loading' }
WSConfig class >> loadDefaults [
    
    "WSBacktracing"
    self maxNumberOfTriesPerGraph: (configFile atPath: {'WSBacktracking' . 'maxNumberOfTriesPerGraph'} default: 10).
    self maxNumberOfRegeneratedGraph: (configFile atPath: {'WSBacktracking' . 'maxNumberOfRegeneratedGraph'} default: 10).
    
    "WS2DGridTopology"
    self gridSafetyMooreRadius: (configFile atPath: {'WS2DGridTopology' . 'gridSafetyMooreRadius'} default: 3).

	 "WS2DRectangularGridTopology"
    self gridSafetyMooreRadius: (configFile atPath: {'WS2DGridTopology' . 'gridSafetyMooreRadius'} default: 3).
    self squareVisitorTileSize: (configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'squareVisitorTileSize'} default: 50).

	 self emptyTileWeight: (configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'empty'} default: 4000).
	 self cornerTileWeight: (configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'corner'} default: 25).
	 self straightTileWeight: (configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'straight'} default: 50).
	 self crossingTileWeight: (configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'crossing'} default: 0).
	 self mergingTileWeight: (configFile atPath:  {'WS2DGridTopology' . 'WS2DRectangularGridTopology' . 'tileWeights' . 'merging'} default: 0).
]

{ #category : 'accessing-backtracking' }
WSConfig class >> maxNumberOfRegeneratedGraph [

	^ maxNumberOfRegeneratedGraph
]

{ #category : 'private' }
WSConfig class >> maxNumberOfRegeneratedGraph: anObject [

	maxNumberOfRegeneratedGraph := anObject
]

{ #category : 'accessing-backtracking' }
WSConfig class >> maxNumberOfTriesPerGraph [

	^ maxNumberOfTriesPerGraph
]

{ #category : 'private' }
WSConfig class >> maxNumberOfTriesPerGraph: anObject [

	maxNumberOfTriesPerGraph := anObject
]

{ #category : 'accessing' }
WSConfig class >> mergingTileWeight [

	^ mergingTileWeight
]

{ #category : 'private' }
WSConfig class >> mergingTileWeight: anObject [

	mergingTileWeight := anObject
]

{ #category : 'loading' }
WSConfig class >> readConfigFile [
	"Read the JSON that contains the configs"
	| file |
    file := (WSObject rootPath, 'config.json') asFileReference.
    
	self configFile: 
	    ((file exists and: [ file contents isNotEmpty ])
	        ifTrue: [ 
	            (NeoJSONReader on: file contents readStream) 
	                mapClass: NeoJSONObject; 
	                next ]
	        ifFalse: [ NeoJSONObject new ]).
]

{ #category : 'reset' }
WSConfig class >> resetInstance [ 
	
	uniqueInstance := nil
]

{ #category : 'accessing' }
WSConfig class >> squareVisitorTileSize [

	^ squareVisitorTileSize
]

{ #category : 'private' }
WSConfig class >> squareVisitorTileSize: anObject [

	squareVisitorTileSize := anObject
]

{ #category : 'accessing' }
WSConfig class >> straightTileWeight [

	^ straightTileWeight
]

{ #category : 'private' }
WSConfig class >> straightTileWeight: anObject [

	straightTileWeight := anObject
]

{ #category : 'accessing' }
WSConfig class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self initialize ]
]

{ #category : 'private' }
WSConfig class >> uniqueInstance: anObject [

	uniqueInstance := anObject
]
