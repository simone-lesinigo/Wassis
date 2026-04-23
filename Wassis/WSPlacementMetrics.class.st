"
Metrics about the placement of the classes on the grid
"
Class {
	#name : 'WSPlacementMetrics',
	#superclass : 'WSMetrics',
	#instVars : [
		'classDistances'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSPlacementMetrics >> classDistances [

	^ classDistances
]

{ #category : 'accessing' }
WSPlacementMetrics >> classDistances: anObject [

	classDistances := anObject
]
