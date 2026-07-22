"
Backtrack of a fixed number of steps
"
Class {
	#name : 'WSFixedStepsBacktracking',
	#superclass : 'WSBacktracking',
	#instVars : [
		'numberOfFixedSteps'
	],
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'accessing' }
WSFixedStepsBacktracking class >> numberOfFixedSteps [
	"How many steps it should go back for bactracking"
		
	^ WSFixedStepsBacktrackingConfig numberOfFixedSteps
]

{ #category : 'accessing' }
WSFixedStepsBacktracking >> numberOfFixedSteps [

	^ self class numberOfFixedSteps
]
