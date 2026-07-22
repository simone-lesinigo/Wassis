"
Config of all the parameters of the backtracking
"
Class {
	#name : 'WSBacktrackingConfig',
	#superclass : 'WSConfig',
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing-backtracking' }
WSBacktrackingConfig class >> maxNumberOfBacktrackPerGraph [
	"How many times WFC should try to find a solution on the same graph (classes collapsed in the same nodes)"

	MaxNumberOfTriesPerGraph ifNil: [ 
		self maxNumberOfBacktrackPerGraph: (self configFile atPath: { self path . 'maxNumberOfBacktrackPerGraph'} default: 10)
	].

	^ MaxNumberOfTriesPerGraph
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxNumberOfBacktrackPerGraph: anObject [

	MaxNumberOfTriesPerGraph := anObject
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxNumberOfRegeneratedGraph: anObject [

	MaxNumberOfRegeneratedGraph := anObject
]

{ #category : 'accessing-backtracking' }
WSBacktrackingConfig class >> maxRegenerationsPerGridSize [
	"How many times WFC should try to find a solution on a graph with the same size (classes collapsed in different nodes)"

	MaxNumberOfRegeneratedGraph ifNil: [ 
		self maxNumberOfRegeneratedGraph: (self configFile atPath: { self path . 'maxRegenerationsPerGridSize'} default: 10)
	].

	^ MaxNumberOfRegeneratedGraph 
]

{ #category : 'accessing' }
WSBacktrackingConfig class >> path [
	
	^ 'WSBacktracking'
]
