"
Config of fixes steps backatracking strategy
"
Class {
	#name : 'WSFixedStepsBacktrackingConfig',
	#superclass : 'WSBacktrackingConfig',
	#classVars : [
		'NumberOfFixedSteps'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WSFixedStepsBacktrackingConfig class >> numberOfFixedSteps [
	"Number of steps it backtracks"

	NumberOfFixedSteps ifNil: [ 
		self numberOfFixedSteps: (self configFile 
			atPath: (self path , { #numberOfFixedSteps })
			default: 10)
	].

	^ NumberOfFixedSteps
]

{ #category : 'private - accessing' }
WSFixedStepsBacktrackingConfig class >> numberOfFixedSteps: anObject [

	NumberOfFixedSteps := anObject
]

{ #category : 'accessing-path' }
WSFixedStepsBacktrackingConfig class >> path [ 

	^ super path, { #WSFixedStepsBacktracking }
]
