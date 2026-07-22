"
Config of all the parameters of the backtracking
"
Class {
	#name : 'WSBacktrackingConfig',
	#superclass : 'WSConfig',
	#classVars : [
		'AllowsSameClassPlacementRetry',
		'BacktrackingStrategy',
		'MaxNumberOfBacktrackPerGraph',
		'MaxRegenerationsPerGridSize',
		'MaxRetriesForSameClassPlacement'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WSBacktrackingConfig class >> allowsSameClassPlacementRetry [
	"If enabled, it backtracks to the grid with all uncollapsed nodes apart from the classes"
	
	AllowsSameClassPlacementRetry ifNil: [ 
		self allowsSameClassPlacementRetry: (self configFile 
			atPath: (self sameClassPlacementPath , { #enabled }) 
			default: true)
	].

	^ AllowsSameClassPlacementRetry
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> allowsSameClassPlacementRetry: anObject [

	AllowsSameClassPlacementRetry := anObject
]

{ #category : 'accessing' }
WSBacktrackingConfig class >> backtrackingStrategy [
	"Defines the backtracking strategy used when WFC hits a contradiction.
		
		Available backtracking strategies:
		
		- 'fixedSteps': Backtracks a fixed number of steps from the current state.
		
		- 'numerousTile': Backtracks to a previous choice point where a node had many available candidate tiles.
		
		- 'percentage': Backtracks by a defined percentage of the total steps executed so far.
		
		- 'similarWeight': Backtracks to a decision point characterized by high entropy (tiles with similar weights/probabilities).
		
		- 'restart': Completely wipes the current grid resolution and restarts from scratch."
	
	BacktrackingStrategy ifNil: [ 
		| backtrackingKey backtrackingMap backtracking |
		
		backtrackingKey := self configFile atPath: { 'classbacktracking' } default: 'restart'.
		
		backtrackingMap := Dictionary new
			at: 'fixedSteps' put: WSFixedStepsBacktracking;
			at: 'numerousTile' put: WSNumerousTilesBacktracking;
			at: 'percentage' put: WSPercentageBacktracking;
			at: 'similarWeight' put: WSSimilarWeightBacktracking;
			at: 'restart' put: WSRestartFromScratchBacktracking;
			yourself.
		
		backtracking := (backtrackingMap at: backtrackingKey ifAbsent: [ self error: 'Unknown backtracking strategy: ', backtrackingKey ]).
			
		self backtrackingStrategy: backtracking.
	].

	^ BacktrackingStrategy
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> backtrackingStrategy: anObject [

	BacktrackingStrategy := anObject
]

{ #category : 'accessing' }
WSBacktrackingConfig class >> maxNumberOfBacktrackPerGraph [
	"How many times WFC should try to find a solution on the same graph (classes collapsed in the same nodes)"

	MaxNumberOfBacktrackPerGraph ifNil: [ 
		self maxNumberOfBacktrackPerGraph: (self configFile 
			atPath: (self path , { #maxNumberOfBacktrackPerGraph })
			default: 10)
	].

	^ MaxNumberOfBacktrackPerGraph
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxNumberOfBacktrackPerGraph: anObject [

	MaxNumberOfBacktrackPerGraph := anObject
]

{ #category : 'accessing' }
WSBacktrackingConfig class >> maxRegenerationsPerGridSize [
	"How many times WFC should try to find a solution on a graph with the same size (classes collapsed in different nodes)"

	MaxRegenerationsPerGridSize ifNil: [ 
		self maxRegenerationsPerGridSize: (self configFile 
			atPath: (self path , { #maxRegenerationsPerGridSize }) 
			default: 10)
	].

	^ MaxRegenerationsPerGridSize
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxRegenerationsPerGridSize: anObject [

	MaxRegenerationsPerGridSize := anObject
]

{ #category : 'accessing' }
WSBacktrackingConfig class >> maxRetriesForSameClassPlacement [
	"If allowsSameClassPlacementRetry is enabled, it decides how many times it should backtrack to the grid with all uncollapsed nodes apart from the classes"

	MaxRetriesForSameClassPlacement ifNil: [ 
		self maxRetriesForSameClassPlacement: (self configFile 
			atPath: (self sameClassPlacementPath , { #maxNumberOfRetries })
			default: 10)
	].

	^ MaxRetriesForSameClassPlacement
]

{ #category : 'private - accessing' }
WSBacktrackingConfig class >> maxRetriesForSameClassPlacement: anObject [

	MaxRetriesForSameClassPlacement := anObject
]

{ #category : 'accessing-path' }
WSBacktrackingConfig class >> path [
	
	^ { #WSBacktracking }
]

{ #category : 'accessing-path' }
WSBacktrackingConfig class >> sameClassPlacementPath [
	
	^ self path , { #retryWithSameClassPlacement }
]
