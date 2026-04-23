"
Collection of all the metrics in Wassis
"
Class {
	#name : 'WSMetrics',
	#superclass : 'WSObject',
	#instVars : [
		'graphMetrics',
		'pathMetrics',
		'performanceMetrics',
		'placementMetrics',
		'softwareMetrics'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSMetrics >> graphMetrics [

	^ graphMetrics
]

{ #category : 'private - accessing' }
WSMetrics >> graphMetrics: anObject [

	graphMetrics := anObject
]

{ #category : 'initialization' }
WSMetrics >> initialize [ 
	super initialize.
	
	self graphMetrics: WSGraphMetrics new.
	self pathMetrics: WSPathMetrics new.
	self performanceMetrics: WSPerformanceMetrics new.
	self placementMetrics: WSPlacementMetrics new.
	self softwareMetrics: WSSoftwareMetrics new.
]

{ #category : 'accessing' }
WSMetrics >> pathMetrics [

	^ pathMetrics
]

{ #category : 'private - accessing' }
WSMetrics >> pathMetrics: anObject [

	pathMetrics := anObject
]

{ #category : 'accessing' }
WSMetrics >> performanceMetrics [

	^ performanceMetrics
]

{ #category : 'private - accessing' }
WSMetrics >> performanceMetrics: anObject [

	performanceMetrics := anObject
]

{ #category : 'accessing' }
WSMetrics >> placementMetrics [

	^ placementMetrics
]

{ #category : 'private - accessing' }
WSMetrics >> placementMetrics: anObject [

	placementMetrics := anObject
]

{ #category : 'accessing' }
WSMetrics >> softwareMetrics [

	^ softwareMetrics
]

{ #category : 'private - accessing' }
WSMetrics >> softwareMetrics: anObject [

	softwareMetrics := anObject
]
