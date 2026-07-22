"
Config of all the parameters of the backtracking
"
Class {
	#name : 'WSBacktrackingConfig',
	#superclass : 'WSConfig',
	#classVars : [
		'MaxNumberOfBacktrackPerGraph',
		'MaxRegenerationsPerGridSize'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing-backtracking' }
WSBacktrackingConfig class >> maxNumberOfBacktrackPerGraph [
	"How many times WFC should try to find a solution on the same graph (classes collapsed in the same nodes)"

	MaxNumberOfBacktrackPerGraph ifNil: [ 
		self maxNumberOfBacktrackPerGraph: (self configFile atPath: { self path . 'maxNumberOfBacktrackPerGraph'} default: 10)
	].

	^ MaxNumberOfBacktrackPerGraph
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxNumberOfBacktrackPerGraph: anObject [

	MaxNumberOfBacktrackPerGraph := anObject
]

{ #category : 'accessing-backtracking' }
WSBacktrackingConfig class >> maxRegenerationsPerGridSize [
	"How many times WFC should try to find a solution on a graph with the same size (classes collapsed in different nodes)"

	MaxRegenerationsPerGridSize ifNil: [ 
		self maxRegenerationsPerGridSize: (self configFile atPath: { self path . 'maxRegenerationsPerGridSize'} default: 10)
	].

	^ MaxRegenerationsPerGridSize
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxRegenerationsPerGridSize: anObject [

	MaxRegenerationsPerGridSize := anObject
]

{ #category : 'accessing' }
WSBacktrackingConfig class >> path [
	
	^ 'WSBacktracking'
]
