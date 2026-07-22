"
Store the checkpoints and the statistics of the backtracking
"
Class {
	#name : 'WSBacktracking',
	#superclass : 'WSObject',
	#instVars : [
		'classesGraphCheckpoint',
		'graphBacktracks',
		'classPlacementBacktracks',
		'emptyGridBacktracks',
		'checkpoints'
	],
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'accessing' }
WSBacktracking class >> allowsSameClassPlacementRetry [
	
	^ WSBacktrackingConfig allowsSameClassPlacementRetry
]

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

{ #category : 'accessing' }
WSBacktracking class >> maxRetriesForSameClassPlacement [
	
	^ WSBacktrackingConfig maxRetriesForSameClassPlacement
]

{ #category : 'instance creation' }
WSBacktracking class >> newWithGraph: aGraph [
	"Initial graph with the classes already placed"

	^ self new
		classesGraphCheckpoint: (aGraph veryDeepCopy)
]

{ #category : 'adding' }
WSBacktracking >> addOneToClassPlacementBacktracks [

	self classPlacementBacktracks: (self classPlacementBacktracks + 1)
]

{ #category : 'adding' }
WSBacktracking >> addOneToEmptyGridBacktracks [

	self emptyGridBacktracks: (self emptyGridBacktracks + 1)
]

{ #category : 'adding' }
WSBacktracking >> addOneToGraphBacktracks [

	self graphBacktracks: (self graphBacktracks + 1)
]

{ #category : 'accessing' }
WSBacktracking >> allowsSameClassPlacementRetry [
	
	^ self class allowsSameClassPlacementRetry
]

{ #category : 'backtracking' }
WSBacktracking >> backtrackInSolver: aSolver [
	"Perform the backtrack based on the strategy. Retun true if backtrack was succesfully executed, false otherwise"
	
	self graphBacktracks > self maxNumberOfBacktrackPerGraph ifTrue: [ ^ false ].
	self addOneToGraphBacktracks.
	
	^ self performBacktrackInSolver: aSolver
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
WSBacktracking >> classPlacementBacktracks [

	^ classPlacementBacktracks
]

{ #category : 'accessing' }
WSBacktracking >> classPlacementBacktracks: anObject [

	classPlacementBacktracks := anObject
]

{ #category : 'accessing' }
WSBacktracking >> classesGraphCheckpoint [

	^ classesGraphCheckpoint
]

{ #category : 'accessing' }
WSBacktracking >> classesGraphCheckpoint: anObject [

	classesGraphCheckpoint := anObject
]

{ #category : 'accessing' }
WSBacktracking >> emptyGridBacktracks [

	^ emptyGridBacktracks
]

{ #category : 'accessing' }
WSBacktracking >> emptyGridBacktracks: anObject [

	emptyGridBacktracks := anObject
]

{ #category : 'evaluating' }
WSBacktracking >> evaluateCheckpointBasedOn: aNode inSolver: aSolver [

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
WSBacktracking >> graphBacktracks [

	^ graphBacktracks
]

{ #category : 'accessing' }
WSBacktracking >> graphBacktracks: anObject [

	graphBacktracks := anObject
]

{ #category : 'initialization' }
WSBacktracking >> initialize [ 
	super initialize.
	self 
		graphBacktracks: 0;
		classPlacementBacktracks: 0;
		emptyGridBacktracks: 0;
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
WSBacktracking >> maxRetriesForSameClassPlacement [
	
	^ self class maxRetriesForSameClassPlacement
]

{ #category : 'backtracking' }
WSBacktracking >> performBacktrackInSolver: aSolver [

	^ self subclassResponsibility
]

{ #category : 'resetting' }
WSBacktracking >> resetClassPlacementBacktracks [

	self classPlacementBacktracks: 0
]

{ #category : 'resetting' }
WSBacktracking >> resetGraphBacktracks [

	self graphBacktracks: 0
]

{ #category : 'deprecated' }
WSBacktracking >> restartCounterOfContradictionperGraph [
	
	self graphBacktracks: 0
]

{ #category : 'restart' }
WSBacktracking >> restartFromClassesGraphForSolver: aSolver [
	"Restart the algorithm with the same nodes collapsed to classes"
	
	aSolver graph: (self classesGraphCheckpoint veryDeepCopy).
	self addOneToClassPlacementBacktracks.
	self resetGraphBacktracks
]

{ #category : 'restart' }
WSBacktracking >> restartFromEmptyGraphForSolver: aSolver [
	"Restart the algorithm collapsing other nodes to classes"

	aSolver recreateGraph.
	self addOneToEmptyGridBacktracks.
	self resetGraphBacktracks.
	self resetClassPlacementBacktracks.
]
