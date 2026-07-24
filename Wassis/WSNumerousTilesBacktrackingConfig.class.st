Class {
	#name : 'WSNumerousTilesBacktrackingConfig',
	#superclass : 'WSBacktrackingConfig',
	#classVars : [
		'TileCountThreshold'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing-path' }
WSNumerousTilesBacktrackingConfig class >> path [ 

	^ super path, #('WSNumerousTilesBacktracking')
]

{ #category : 'accessing' }
WSNumerousTilesBacktrackingConfig class >> tileCountThreshold [
	"Number of tiles that a node must have to save the checkpoint"

	TileCountThreshold ifNil: [
		| tileCountValue |
		tileCountValue := (self configFile atPath: (self path , #('tileCountThreshold')) default: 7).
		
		(tileCountValue between: 0 and: 15) ifFalse: [ self error: 'Percentage value must be between 0 and 15' ].	 
		self tileCountThreshold: tileCountValue
	].

	^ TileCountThreshold
]

{ #category : 'as yet unclassified' }
WSNumerousTilesBacktrackingConfig class >> tileCountThreshold: anObject [

	TileCountThreshold := anObject
]
