"
When a contradiction occurs, wipe all the grid and restart
"
Class {
	#name : 'WSRestartFromScratchBacktracking',
	#superclass : 'WSBacktracking',
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'evaluating' }
WSRestartFromScratchBacktracking >> evaluateCheckpointBasedOn: aWSCollapseEvent historySize: historySize withGraph: aGraph [
	"This method is empty on purpose as it should not save any checkpoint"

]

{ #category : 'backtracking' }
WSRestartFromScratchBacktracking >> performBacktrackInSolver: aSolver [

	^ false
]
