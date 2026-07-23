"
Backtrack of a fixed number of steps
"
Class {
	#name : 'WSFixedStepsBacktracking',
	#superclass : 'WSBacktracking',
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'accessing' }
WSFixedStepsBacktracking class >> numberOfFixedSteps [
	"How many steps it should go back for bactracking"
		
	^ WSFixedStepsBacktrackingConfig numberOfFixedSteps
]

{ #category : 'evaluating' }
WSFixedStepsBacktracking >> evaluateCheckpointBasedOn: aWSCollapseEvent historySize: historySize withGraph: aGraph [
	"As it returns back of a certain number of steps, we have to save the graph at every collapse"

	self addCheckpoint: (
		WSCheckpoint 
			fromCollapseEvent: aWSCollapseEvent 
			withHistorySize: historySize 
			withGraph: aGraph
		)
]

{ #category : 'accessing' }
WSFixedStepsBacktracking >> numberOfFixedSteps [

	^ self class numberOfFixedSteps
]

{ #category : 'backtracking' }
WSFixedStepsBacktracking >> performBacktrackInSolver: aSolver [
	"Backtrack of a certain number of steps. If the number of checkpoints is insufficient, it returns to the first one"
	
	| targetIndex targetCheckpoint |
	targetIndex := (self checkpoints size - self numberOfFixedSteps + 1) max: 1.
	targetCheckpoint := self checkpoints at: targetIndex.
	
	^ self rollbackToCheckpointAtIndex: targetIndex inSolver: aSolver
]
