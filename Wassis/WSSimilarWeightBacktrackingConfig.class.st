"
Config of similar weight backatracking strategy. You have to define the percentage of tile have weights within a certain percentage range
"
Class {
	#name : 'WSSimilarWeightBacktrackingConfig',
	#superclass : 'WSBacktrackingConfig',
	#classVars : [
		'MinSimilarTilesPercentage',
		'WeightDifferencePercentage'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WSSimilarWeightBacktrackingConfig class >> minSimilarTilesPercentage [
	"Percentage of tiles that have to be considered"

	MinSimilarTilesPercentage ifNil: [
		| percentageValue |
		percentageValue := (self configFile atPath: (self path , #('minSimilarTilesPercentage')) default: 15).

		(percentageValue between: 0 and: 100) ifFalse: [ self error: 'Percentage value must be between 0 and 100' ].	 
		self minSimilarTilesPercentage: percentageValue
	].

	^ MinSimilarTilesPercentage
]

{ #category : 'private - accessing' }
WSSimilarWeightBacktrackingConfig class >> minSimilarTilesPercentage: anObject [

	MinSimilarTilesPercentage := anObject
]

{ #category : 'accessing-path' }
WSSimilarWeightBacktrackingConfig class >> path [ 

	^ super path, #('WSSimilarWeightBacktracking')
]

{ #category : 'accessing' }
WSSimilarWeightBacktrackingConfig class >> weightDifferencePercentage [
	"Percentage of difference between the weights"

	WeightDifferencePercentage ifNil: [
		| percentageValue |
		percentageValue := (self configFile atPath: (self path , #('weightDifferencePercentage')) default: 15).
		
		(percentageValue between: 0 and: 100) ifFalse: [ self error: 'Percentage value must be between 0 and 100' ].	 
		self weightDifferencePercentage: percentageValue
	].

	^ WeightDifferencePercentage
]

{ #category : 'private - accessing' }
WSSimilarWeightBacktrackingConfig class >> weightDifferencePercentage: anObject [

	WeightDifferencePercentage := anObject
]
