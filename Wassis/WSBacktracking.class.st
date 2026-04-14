"
Store the checkpoints and the statistics of the backtracking
"
Class {
	#name : 'WSBacktracking',
	#superclass : 'WSObject',
	#instVars : [
		'classesGraphCheckpoint',
		'maxNOfTriesPerGraph',
		'maxNOfRegeneratedGraph',
		'nOfContradicitonsPerGraph',
		'nOfRegeneratedGraph'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'default-settings' }
WSBacktracking class >> defaultMaxNOfRegeneratedGraph [
	
	^ 80
]

{ #category : 'default-settings' }
WSBacktracking class >> defaultmaxNOfTriesPerGraph [
	
	^ 10
]

{ #category : 'instance creation' }
WSBacktracking class >> newWithGraph: aGraph [

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
		maxNOfTriesPerGraph: self class defaultmaxNOfTriesPerGraph;
		maxNOfRegeneratedGraph: self class defaultMaxNOfRegeneratedGraph
]

{ #category : 'accessing' }
WSBacktracking >> maxNOfRegeneratedGraph [

	^ maxNOfRegeneratedGraph
]

{ #category : 'accessing' }
WSBacktracking >> maxNOfRegeneratedGraph: anObject [

	maxNOfRegeneratedGraph := anObject
]

{ #category : 'accessing' }
WSBacktracking >> maxNOfTriesPerGraph [

	^ maxNOfTriesPerGraph
]

{ #category : 'accessing' }
WSBacktracking >> maxNOfTriesPerGraph: anObject [

	maxNOfTriesPerGraph := anObject
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
	
	self classesGraphCheckpoint: newGraph veryDeepCopy.
	aSolver graph: newGraph.
	
	self addOneToContradictionPerGraph.
	self restartCounterOfContradictionperGraph.
	self addOneToRegeneratedGraph 
]
