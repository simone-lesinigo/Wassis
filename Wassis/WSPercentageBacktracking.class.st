"
Backtrack of a certain percentage on the total

"
Class {
	#name : 'WSPercentageBacktracking',
	#superclass : 'WSBacktracking',
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'computation' }
WSPercentageBacktracking class >> percentage [
	
	^ WSPercentageBacktrackingConfig percentage
]

{ #category : 'evaluating' }
WSPercentageBacktracking >> evaluateCheckpointBasedOn: aWSCollapseEvent historySize: historySize withGraph: aGraph [
	"As it returns back of a certain number of steps, we have to save the graph at every collapse"

	self addCheckpoint: (
		WSCheckpoint 
			fromCollapseEvent: aWSCollapseEvent 
			withHistorySize: historySize 
			withGraph: aGraph
		)
]

{ #category : 'computation' }
WSPercentageBacktracking >> percentage [
	
	^ self class percentage
]

{ #category : 'backtracking' }
WSPercentageBacktracking >> performBacktrackInSolver: aSolver [
	"Backtrack of a certain percentage. If the number of checkpoints is insufficient, it returns to the first one"
	
	| stepsToGoBack targetIndex |
	self checkpoints ifEmpty: [ ^ false ].

	stepsToGoBack := ((self checkpoints size * self percentage / 100) rounded) max: 1.
	targetIndex := (self checkpoints size - stepsToGoBack + 1) max: 1.
	
	^ self rollbackToCheckpointAtIndex: targetIndex inSolver: aSolver
]
