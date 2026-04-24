"
Metrics about the placement of the classes on the grid
"
Class {
	#name : 'WSPlacementMetrics',
	#superclass : 'WSAbstractMetrics',
	#instVars : [
		'classDistances',
		'avgConnectedClassesDistance'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSPlacementMetrics >> avgConnectedClassesDistance [

	^ avgConnectedClassesDistance
]

{ #category : 'accessing' }
WSPlacementMetrics >> avgConnectedClassesDistance: anObject [

	avgConnectedClassesDistance := anObject
]

{ #category : 'accessing' }
WSPlacementMetrics >> classDistances [

	^ classDistances
]

{ #category : 'accessing' }
WSPlacementMetrics >> classDistances: anObject [

	classDistances := anObject
]
