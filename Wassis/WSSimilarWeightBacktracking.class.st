"
Backtrack at a point where there were multiple tiles with similar weight
"
Class {
	#name : 'WSSimilarWeightBacktracking',
	#superclass : 'WSBacktracking',
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'accessing' }
WSSimilarWeightBacktracking class >> minSimilarTilesPercentage [
	
	^ WSSimilarWeightBacktrackingConfig minSimilarTilesPercentage
]

{ #category : 'accessing' }
WSSimilarWeightBacktracking class >> weightDifferencePercentage [
	
	^ WSSimilarWeightBacktrackingConfig weightDifferencePercentage
]

{ #category : 'evaluating' }
WSSimilarWeightBacktracking >> evaluateCheckpointBasedOn: aWSCollapseEvent historySize: historySize withGraph: aGraph [
	"Creates a checkpoint if there is a group of tiles with similar weights"

	| possibleTiles |
	possibleTiles := aWSCollapseEvent node possibleTiles.

	(self hasEnoughSimilarWeightTiles: possibleTiles) ifTrue: [ 
		self addCheckpoint: (
			WSCheckpoint 
				fromCollapseEvent: aWSCollapseEvent 
				withHistorySize: historySize 
				withGraph: aGraph
			) ]
]

{ #category : 'testing' }
WSSimilarWeightBacktracking >> hasEnoughSimilarWeightTiles: aCollectionOfTiles [
	"Returns true if at least minSimilarTilesPercentage % of non-zero tiles have weights within weightDifferencePercentage % of each other"

	| nonZeroWeights sortedWeights windowSize |
	nonZeroWeights := (aCollectionOfTiles collect: #weight) reject: #isZero.

	windowSize := ((nonZeroWeights size * self minSimilarTilesPercentage / 100) ceiling) max: 2.
	nonZeroWeights size < windowSize ifTrue: [ ^ false ].

	sortedWeights := nonZeroWeights asSortedCollection.

	1 to: (sortedWeights size - windowSize + 1) do: [ :i |
		| minWeight maxWeight allowedDelta |
		minWeight := sortedWeights at: i.
		maxWeight := sortedWeights at: (i + windowSize - 1).
		
		allowedDelta := minWeight * self weightDifferencePercentage / 100.
		
		(maxWeight - minWeight) <= allowedDelta ifTrue: [ ^ true ] ].

	^ false
]

{ #category : 'accessing' }
WSSimilarWeightBacktracking >> minSimilarTilesPercentage [
	
	^ self class minSimilarTilesPercentage
]

{ #category : 'backtracking' }
WSSimilarWeightBacktracking >> performBacktrackInSolver: aSolver [

	^ self rollbackToCheckpointAtIndex: self checkpoints size inSolver: aSolver
]

{ #category : 'accessing' }
WSSimilarWeightBacktracking >> weightDifferencePercentage [
	
	^ self class weightDifferencePercentage
]
