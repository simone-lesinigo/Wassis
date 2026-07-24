"
Backtrack to a choice where there were multiple tiles
"
Class {
	#name : 'WSNumerousTilesBacktracking',
	#superclass : 'WSBacktracking',
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'accessing' }
WSNumerousTilesBacktracking class >> tileCountThreshold [
	
	^ WSNumerousTilesBacktrackingConfig tileCountThreshold
]

{ #category : 'evaluating' }
WSNumerousTilesBacktracking >> evaluateCheckpointBasedOn: aWSCollapseEvent historySize: historySize withGraph: aGraph [
	"Creates a checkpoint if the node being collapsed has at least tileCountThreshold possible tiles"

	| availableTilesCount |
	availableTilesCount := aWSCollapseEvent node possibleTiles size.
	
	availableTilesCount >= self tileCountThreshold ifTrue: [ 
		self addCheckpoint: (
			WSCheckpoint 
				fromCollapseEvent: aWSCollapseEvent 
				withHistorySize: historySize 
				withGraph: aGraph
			) ]
]

{ #category : 'backtracking' }
WSNumerousTilesBacktracking >> performBacktrackInSolver: aSolver [

	^ self rollbackToCheckpointAtIndex: self checkpoints size inSolver: aSolver
]

{ #category : 'accessing' }
WSNumerousTilesBacktracking >> tileCountThreshold [

	^ self class tileCountThreshold
]
