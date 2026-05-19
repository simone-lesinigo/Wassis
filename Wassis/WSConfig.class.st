"
Config of all the parameters of the algorithm
"
Class {
	#name : 'WSConfig',
	#superclass : 'WSObject',
	#classVars : [
		'ClassTileWeight',
		'ConfigFile',
		'EmptyTileWeight',
		'IsHeadless',
		'MaxNumberOfRegeneratedGraph',
		'MaxNumberOfTriesPerGraph',
		'PlacementStrategy'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing-tileWeight' }
WSConfig class >> classTileWeight [
	
	ClassTileWeight ifNil: [ 
		self classTileWeight: 
			(self configFile atPath:  {'WSTile' . 'classTileWeight'} default: 1).
	].

	^ ClassTileWeight
]

{ #category : 'private - accessing' }
WSConfig class >> classTileWeight: anObject [
	
	ClassTileWeight := anObject
	
	
]

{ #category : 'accessing' }
WSConfig class >> configFile [

	ConfigFile ifNil: [ self readConfigFile ].

	^ ConfigFile
]

{ #category : 'private - accessing' }
WSConfig class >> configFile: anObject [

	ConfigFile := anObject
]

{ #category : 'accessing-tileWeight' }
WSConfig class >> emptyTileWeight [
	
	EmptyTileWeight ifNil: [ 
		self emptyTileWeight: 
			(self configFile atPath:  {'WSTile' . 'emptyTileWeight'} default: 4000).
	].

	^ EmptyTileWeight
]

{ #category : 'private - accessing' }
WSConfig class >> emptyTileWeight: anObject [

	EmptyTileWeight := anObject
]

{ #category : 'accessing' }
WSConfig class >> isHeadless [ 

	IsHeadless ifNil: [ 
		self isHeadless: 
			(self configFile atPath:  { 'isHeadless' } default: true).
	].

	^ IsHeadless
]

{ #category : 'private - accessing' }
WSConfig class >> isHeadless: anObject [

	IsHeadless := anObject
]

{ #category : 'testing' }
WSConfig class >> isNotHeadless [
	
	^ self isHeadless not 
]

{ #category : 'accessing-backtracking' }
WSConfig class >> maxNumberOfRegeneratedGraph [

	MaxNumberOfRegeneratedGraph ifNil: [ 
		self maxNumberOfRegeneratedGraph: (self configFile atPath: {'WSBacktracking' . 'maxNumberOfRegeneratedGraph'} default: 10)
	].

	^ MaxNumberOfRegeneratedGraph 
]

{ #category : 'private - accessing' }
WSConfig class >> maxNumberOfRegeneratedGraph: anObject [

	MaxNumberOfRegeneratedGraph := anObject
]

{ #category : 'accessing-backtracking' }
WSConfig class >> maxNumberOfTriesPerGraph [

	MaxNumberOfTriesPerGraph ifNil: [ 
		self maxNumberOfTriesPerGraph: (self configFile atPath: {'WSBacktracking' . 'maxNumberOfTriesPerGraph'} default: 10)
	].

	^ MaxNumberOfTriesPerGraph
]

{ #category : 'private - accessing' }
WSConfig class >> maxNumberOfTriesPerGraph: anObject [

	MaxNumberOfTriesPerGraph := anObject
]

{ #category : 'accessing' }
WSConfig class >> placementStrategy [
	
	PlacementStrategy ifNil: [ 
		| strategyKey strategyMap |
		
		strategyKey := self configFile atPath: {'placementStrategy'} default: 'classicMDS'.
		
		strategyMap := Dictionary new
			at: 'classicMDS' put: WSClassicMDSLayoutStrategy;
			at: 'metricMDS' put: WSMetricMDSLayoutStrategy ;
			yourself.
			
		self placementStrategy: (strategyMap at: strategyKey).
	].

	^ PlacementStrategy
]

{ #category : 'private - accessing' }
WSConfig class >> placementStrategy: anObject [

	PlacementStrategy := anObject
]

{ #category : 'loading' }
WSConfig class >> readConfigFile [
	"Read the JSON that contains the configs"
	| file |
    file := (WSObject resourcesRootPath / 'config.json') asFileReference.
    
	self configFile: 
	    ((file exists and: [ file contents isNotEmpty ])
	        ifTrue: [ 
	            (NeoJSONReader on: file contents readStream) 
	                mapClass: NeoJSONObject; 
	                next ]
	        ifFalse: [ NeoJSONObject new ]).
]

{ #category : 'class initialization' }
WSConfig class >> reset [
	
	self configFile: nil.
	self maxNumberOfRegeneratedGraph: nil.
	self maxNumberOfTriesPerGraph: nil.
	self emptyTileWeight: nil.
	self classTileWeight: nil.
	self isHeadless: nil.
	self placementStrategy: nil.
	
	self allSubclassesDo: [ :eachSubclass | eachSubclass reset ]
]
