"
Store the checkpoints and the statistics of the backtracking
"
Class {
	#name : 'WSBacktracking',
	#superclass : 'WSObject',
	#instVars : [
		'classesGraphCheckpoint',
		'nOfContradicitonsPerGraph',
		'nOfRegeneratedGraph',
		'checkpoints'
	],
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'default-settings' }
WSBacktracking class >> maxNumberOfBacktrackPerGraph [
	"How many times WFC should try to find a solution on the same graph (classes collapsed in the same nodes)"
	
	^ WSBacktrackingConfig maxNumberOfBacktrackPerGraph 
]

{ #category : 'default-settings' }
WSBacktracking class >> maxRegenerationsPerGridSize [
	"How many times WFC should try to find a solution on a graph with the same size (classes collapsed in different nodes)"
	
	^ WSBacktrackingConfig maxRegenerationsPerGridSize 
]

{ #category : 'instance creation' }
WSBacktracking class >> newWithGraph: aGraph [
	"Initial graph with the classes already placed"

	^ self new
		classesGraphCheckpoint: (aGraph veryDeepCopy)
]

{ #category : 'adding' }
WSBacktracking >> addOneToContradictionPerGraph [

	self nOfContradicitonsPerGraph: (self nOfContradicitonsPerGraph + 1)
]

{ #category : 'adding' }
WSBacktracking >> addOneToRegeneratedGraph [

	self nOfRegeneratedGraph: (self nOfRegeneratedGraph + 1)
]

{ #category : 'accessing' }
WSBacktracking >> checkpoints [

	^ checkpoints
]

{ #category : 'accessing' }
WSBacktracking >> checkpoints: anObject [

	checkpoints := anObject
]

{ #category : 'accessing' }
WSBacktracking >> classesGraphCheckpoint [

	^ classesGraphCheckpoint
]

{ #category : 'accessing' }
WSBacktracking >> classesGraphCheckpoint: anObject [

	classesGraphCheckpoint := anObject
]

{ #category : 'initialization' }
WSBacktracking >> initialize [ 
	super initialize.
	self 
		nOfContradicitonsPerGraph: 0;
		nOfRegeneratedGraph: 0;
		checkpoints: OrderedCollection new
]

{ #category : 'accessing' }
WSBacktracking >> maxNumberOfBacktrackPerGraph [
	"How many times WFC should try to find a solution on the same graph (classes collapsed in the same nodes)"
	
	^ self class maxNumberOfBacktrackPerGraph
]

{ #category : 'accessing' }
WSBacktracking >> maxRegenerationsPerGridSize [
	
	^ self class maxRegenerationsPerGridSize
]

{ #category : 'accessing' }
WSBacktracking >> nOfContradicitonsPerGraph [

	^ nOfContradicitonsPerGraph
]

{ #category : 'accessing' }
WSBacktracking >> nOfContradicitonsPerGraph: anObject [

	nOfContradicitonsPerGraph := anObject
]

{ #category : 'accessing' }
WSBacktracking >> nOfRegeneratedGraph [

	^ nOfRegeneratedGraph
]

{ #category : 'accessing' }
WSBacktracking >> nOfRegeneratedGraph: anObject [

	nOfRegeneratedGraph := anObject
]

{ #category : 'restart' }
WSBacktracking >> restartCounterOfContradictionperGraph [
	
	self nOfContradicitonsPerGraph: 0
]

{ #category : 'restart' }
WSBacktracking >> restartFromClassesGraphForSolver: aSolver [
	"Restart the algorithm with the same nodes collapsed to classes"

	aSolver graph: (self classesGraphCheckpoint veryDeepCopy).
	self addOneToContradictionPerGraph.
]

{ #category : 'restart' }
WSBacktracking >> restartFromEmptyGraphForSolver: aSolver [
	"Restart the algorithm collapsing other nodes to classes"
	| newGraph |
	newGraph := aSolver topology createGraph.
	
	"self classesGraphCheckpoint: newGraph veryDeepCopy."
	aSolver graph: newGraph.
	
	self addOneToContradictionPerGraph.
	self restartCounterOfContradictionperGraph.
	self addOneToRegeneratedGraph 
]
