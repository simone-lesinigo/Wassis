"
Config of all the parameters of the algorithm
"
Class {
	#name : 'WSConfig',
	#superclass : 'WSObject',
	#classVars : [
		'ClassPlacingOrder',
		'ClassTileWeight',
		'ConfigFile',
		'ConnectionAssignmentStrategy',
		'EmptyTileWeight',
		'HeapType',
		'IsHeadless',
		'MaxNumberOfRegeneratedGraph',
		'MaxNumberOfTriesPerGraph',
		'PathTargetStrategy',
		'PlacementStrategy',
		'SaveFailedExecution'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WSConfig class >> classPlacingOrder [
	
	ClassPlacingOrder ifNil: [ 
		| placingOrderKey placingOrderMap placingOrder |
		
		placingOrderKey := self configFile atPath: {'classPlacingOrder'} default: 'random'.
		
		placingOrderMap := Dictionary new
			at: 'random' put: WSRandomClassPlacingOrder;
			at: 'minConnectionFirst' put: WSMinConnectionFirstClassPlacingOrder;
			at: 'maxConnectionFirst' put: WSMaxConnectionFirstClassPlacingOrder;
			at: 'BFSmin' put: WSBFSMinClassPlacingOrder;
			at: 'BFSmax' put: WSBFSMaxClassPlacingOrder;
			yourself.
		
		placingOrder := (placingOrderMap at: placingOrderKey ifAbsent: [ self error: 'Unknown class placing order: ', placingOrderKey ]).
			
		self classPlacingOrder: placingOrder new.
	].

	^ ClassPlacingOrder
]

{ #category : 'private - accessing' }
WSConfig class >> classPlacingOrder: anObject [
	
	ClassPlacingOrder := anObject
	
	
]

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

{ #category : 'accessing-pathID' }
WSConfig class >> connectionAssignmentStrategy [
	
	ConnectionAssignmentStrategy ifNil: [ 
		| strategyString |
		strategyString := self configFile 
			atPath: #('connectionAssignmentStrategy') 
			default: 'grouped'.
			
		(#('grouped' 'greedy') includes: strategyString) ifFalse: [ 
			strategyString := 'grouped' ].
			
		self connectionAssignmentStrategy: strategyString capitalized asSymbol.
	].

	^ ConnectionAssignmentStrategy
]

{ #category : 'accessing-pathID' }
WSConfig class >> connectionAssignmentStrategy: anObject [

	ConnectionAssignmentStrategy := anObject
]

{ #category : 'accessing' }
WSConfig class >> dijkstraTraversingPathWeight [
	
	^ 100
]

{ #category : 'accessing-symbols' }
WSConfig class >> emptyEdgeSymbol [ 
	
	^ 'emptyEdge'
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

{ #category : 'accessing-symbols' }
WSConfig class >> firstPathSymbol [
	
	^ 'firstPath'
]

{ #category : 'accessing-heap' }
WSConfig class >> heapType [
	
	HeapType ifNil: [ 
		self heapType: 
			(self configFile atPath:  {'heapType'} default: 'maxHeap').
	].

	^ HeapType 
]

{ #category : 'private - accessing' }
WSConfig class >> heapType: anObject [

	HeapType := anObject
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

{ #category : 'accessing-heap' }
WSConfig class >> isMaxHeap [
	
	^ self heapType = 'maxHeap'
]

{ #category : 'accessing-heap' }
WSConfig class >> isMinHeap [

	^ self heapType = 'minHeap'
]

{ #category : 'accessing' }
WSConfig class >> isNotHeadless [
	
	^ self isHeadless not 
]

{ #category : 'accessing-symbols' }
WSConfig class >> isPathID: aSymbol [
	"Every symbol that is not a placeHolder and not equal to the emptyEdgeSymbol, is by construction a pathID symbol"

    ^ (self isPlaceholder: aSymbol) not and: [ aSymbol ~= self emptyEdgeSymbol ]
]

{ #category : 'accessing-symbols' }
WSConfig class >> isPlaceholder: aSymbol [

    ^ aSymbol = self firstPathSymbol or: [ aSymbol = self secondPathSymbol ]
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
WSConfig class >> pathTargetStrategy [
	
	PathTargetStrategy ifNil: [ 
		| pathTargetKey pathTargetMap pathTarget |
		
		pathTargetKey := self configFile atPath: {'pathTargetStrategy'} default: 'closest'.
		
		pathTargetMap := Dictionary new
			at: 'centroid' put: WSCentroidPathTargetStrategy;
			at: 'closest' put: WSClosestPathTargetStrategy;
			at: 'closest-exit' put: WSClosestExitPathTargetStrategy;
			at: 'none' put: WSNonePathTargetStrategy;
			yourself.
		
		pathTarget := (pathTargetMap at: pathTargetKey ifAbsent: [ self error: 'Unknown path target strategy: ', pathTargetKey ]).
			
		self pathTargetStrategy: pathTarget new.
	].

	^ PathTargetStrategy 
]

{ #category : 'private - accessing' }
WSConfig class >> pathTargetStrategy: anObject [
	
	PathTargetStrategy := anObject
	
	
]

{ #category : 'accessing' }
WSConfig class >> placementStrategy [
	
	PlacementStrategy ifNil: [ 
		| strategyKey strategyMap |
		
		strategyKey := self configFile atPath: {'placementStrategy'} default: 'metricMDS'.
		
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
	"Clean all the values of the cofnig attributes"
	
	self classPool keysAndValuesDo: [ :varName :value | self classPool at: varName put: nil ].
	
	self allSubclassesDo: [ :subclass | 
		subclass classPool keysAndValuesDo: [ :varName :value | subclass classPool at: varName put: nil ] ]
]

{ #category : 'accessing' }
WSConfig class >> saveFailedExecution [

	SaveFailedExecution ifNil: [ 
		self saveFailedExecution: 
			(self configFile atPath:  { 'saveFailedExecution' } default: false).
	].

	^ SaveFailedExecution
]

{ #category : 'private - accessing' }
WSConfig class >> saveFailedExecution: anObject [
	
	SaveFailedExecution := anObject
]

{ #category : 'accessing-symbols' }
WSConfig class >> secondPathSymbol [
	
	^ 'secondPath'
]
