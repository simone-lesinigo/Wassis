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
WSBacktracking >> addCheckpoint: aWSCheckpoint [
	
	self checkpoints add: aWSCheckpoint
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
WSBacktracking >> attemptBacktrackInSolver: aSolver [
	"Perform the backtrack based on the strategy. Retun true if backtrack was succesfully executed, false otherwise"
	
	self checkpoints ifEmpty: [ ^ false ].
		
	self canBacktrackOnGraph ifFalse: [ ^ false ].
	
	self addOneToGraphBacktracks.
	WSLogger log: 
		('Backtrack on the same graph: {1}' format: { self graphBacktracks asString }).
	
	^ self performBacktrackInSolver: aSolver.
]

{ #category : 'testing' }
WSBacktracking >> canBacktrackOnGraph [
	"Check if you can backtrack on the same execution"
	
	^ self graphBacktracks < self maxNumberOfBacktrackPerGraph
]

{ #category : 'testing' }
WSBacktracking >> canRestartWithEmptyGraph [
	"Check if it can restart with a different positioning of classes but same grid size"

	^ self emptyGridBacktracks < self maxRegenerationsPerGridSize
]

{ #category : 'testing' }
WSBacktracking >> canRetrySameClassPlacement [
	"Check if the restart from the same positioninf of classes is enabled. If it is, check if it can do it"

	^ self allowsSameClassPlacementRetry and: [ 
		self classPlacementBacktracks < self maxRetriesForSameClassPlacement ]
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

{ #category : 'cleanup' }
WSBacktracking >> clearCheckpoints [
	
	self checkpoints: OrderedCollection new
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
WSBacktracking >> evaluateCheckpointBasedOn: aWSCollapseEvent historySize: historySize withGraph: aGraph [

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

{ #category : 'backtracking' }
WSBacktracking >> handleContradictionFor: aSolver [
	"Manage what to do when a contradiction occurs"

	(self attemptBacktrackInSolver: aSolver) ifTrue: [ ^ self ].

	aSolver executionHistory reset.

	self canRetrySameClassPlacement ifTrue: [ 
		^ self restartFromClassesGraphForSolver: aSolver ].
	
	self canRestartWithEmptyGraph ifTrue: [ 
		^ self restartFromEmptyGraphForSolver: aSolver ].
	
	WSMaxTriesReached signal.
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
	
	self addOneToClassPlacementBacktracks.
	WSLogger log: 
		('Restarted from same positioning of classes {1}' format: { self classPlacementBacktracks asString }).
	
	aSolver graph: self classesGraphCheckpoint veryDeepCopy.
	self resetGraphBacktracks.
	self clearCheckpoints.
	
	
]

{ #category : 'restart' }
WSBacktracking >> restartFromEmptyGraphForSolver: aSolver [
	"Restart the algorithm collapsing other nodes to classes"

	self addOneToEmptyGridBacktracks.
	WSLogger log: 
		('Restarted with different positioning of classes {1}' format: { self emptyGridBacktracks asString }).

	aSolver recreateGraph.
	self resetGraphBacktracks.
	self resetClassPlacementBacktracks.
	self clearCheckpoints.
]

{ #category : 'backtracking' }
WSBacktracking >> rollbackToCheckpointAtIndex: targetIndex inSolver: aSolver [

	| targetCheckpoint |
	targetCheckpoint := self checkpoints at: targetIndex.

	aSolver graph: targetCheckpoint graphCopy veryDeepCopy.

	aSolver executionHistory truncateTo: targetCheckpoint historySize.

	self checkpoints: (self checkpoints copyFrom: 1 to: targetIndex - 1).

	^ true
]
