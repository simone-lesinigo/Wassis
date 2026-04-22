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
	
	"WSBacktracking"
	self maxNumberOfTriesPerGraph: 2. 
	self maxNumberOfRegeneratedGraph: 2. 
	
	"WS2DGridTopology"
	self gridSafetyMooreRadius: 3.
	
	"WS2DSquareVisitor"
	self squareVisitorTileSize: 50.
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
