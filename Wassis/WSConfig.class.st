"
Config of all the parameters of the algorithm
"
Class {
	#name : 'WSConfig',
	#superclass : 'WSObject',
	#classVars : [
		'ConfigFile',
		'MaxNumberOfRegeneratedGraph',
		'MaxNumberOfTriesPerGraph'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WSConfig class >> configFile [

	ConfigFile ifNil: [ self readConfigFile ].

	^ ConfigFile
]

{ #category : 'private - accessing' }
WSConfig class >> configFile: anObject [

	ConfigFile := anObject
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

{ #category : 'class initialization' }
WSConfig class >> reset [
	
	self configFile: nil.
	self maxNumberOfRegeneratedGraph: nil.
	self maxNumberOfTriesPerGraph: nil.
	
	self withAllSubclassesDo: [ :eachSubclass | eachSubclass reset ]
]
