Class {
	#name : 'WSPercentageBacktrackingConfig',
	#superclass : 'WSBacktrackingConfig',
	#classVars : [
		'Percentage'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing-path' }
WSPercentageBacktrackingConfig class >> path [ 

	^ super path, #('WSPercentageBacktracking')
]

{ #category : 'computation' }
WSPercentageBacktrackingConfig class >> percentage [
	"Percentage on the total number of steps a;ready done it has to backtrack"

	Percentage ifNil: [
		| percentageValue |
		percentageValue := (self configFile atPath: (self path , #('percentage')) default: 15).
		
		(percentageValue between: 0 and: 100) ifFalse: [ self error: 'Percentage value must be between 0 and 100' ].	 
		self percentage: percentageValue
	].

	^ Percentage
]

{ #category : 'private - accessing' }
WSPercentageBacktrackingConfig class >> percentage: anObject [

	Percentage := anObject
]
