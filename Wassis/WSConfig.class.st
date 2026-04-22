"
Config of all the parameters of the algorithm
"
Class {
	#name : 'WSConfig',
	#superclass : 'WSObject',
	#classInstVars : [
		'uniqueInstance',
		'maxNumberOfTriesPerGraph',
		'maxNumberOfRegeneratedGraph',
		'gridSafetyMooreRadius',
		'squareVisitorTileSize'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing-2DGrid' }
WSConfig class >> gridSafetyMooreRadius [

	^ gridSafetyMooreRadius
]

{ #category : 'private' }
WSConfig class >> gridSafetyMooreRadius: anObject [

	gridSafetyMooreRadius := anObject
]

{ #category : 'class initialization' }
WSConfig class >> initialize [ 
	
	self loadDefaults
]

{ #category : 'loading' }
WSConfig class >> loadDefaults [

	 | config |
    config := self readConfigFile.
    
    "WSBacktracing"
    self maxNumberOfTriesPerGraph: (config atPath: {'WSBacktracking' . 'maxNumberOfTriesPerGraph'} default: 10).
    self maxNumberOfRegeneratedGraph: (config atPath: {'WSBacktracking' . 'maxNumberOfRegeneratedGraph'} default: 10).
    
    "WS2DGridTopology"
    self gridSafetyMooreRadius: (config atPath: {'WS2DGridTopology' . 'gridSafetyMooreRadius'} default: 3).
    
    "WS2DSquareVisitor"
    self squareVisitorTileSize: (config atPath:  {'WS2DSquareVisitor' . 'squareVisitorTileSize'} default: 50).
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

{ #category : 'loading' }
WSConfig class >> readConfigFile [
	"Read the JSON that contains the configs"
	| file |
    file := (WSObject rootPath, 'config.json') asFileReference.
    
    ^ (file exists and: [ file contents isNotEmpty ])
        ifTrue: [ 
            (NeoJSONReader on: file contents readStream) 
                mapClass: NeoJSONObject; 
                next ]
        ifFalse: [ NeoJSONObject new ].
]

{ #category : 'reset' }
WSConfig class >> resetInstance [ 
	
	uniqueInstance := nil
]

{ #category : 'accessing-2DGrid' }
WSConfig class >> squareVisitorTileSize [

	^ squareVisitorTileSize
]

{ #category : 'private' }
WSConfig class >> squareVisitorTileSize: anObject [

	squareVisitorTileSize := anObject
]

{ #category : 'accessing' }
WSConfig class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self initialize ]
]

{ #category : 'private' }
WSConfig class >> uniqueInstance: anObject [

	uniqueInstance := anObject
]
