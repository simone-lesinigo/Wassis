"
Metric of a single execution
"
Class {
	#name : 'WSCurrentMetrics',
	#superclass : 'DynamicVariable',
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'metrics-accessing' }
WSCurrentMetrics class >> getGraphMetrics [ 
	
	^ self value graphMetrics 
]

{ #category : 'metrics-accessing' }
WSCurrentMetrics class >> getPathMetrics [ 
	
	^ self value pathMetrics 
]

{ #category : 'metrics-accessing' }
WSCurrentMetrics class >> getPerformanceMetrics [ 
	
	^ self value performanceMetrics 
]

{ #category : 'metrics-accessing' }
WSCurrentMetrics class >> getPlacementMetrics [ 
	
	^ self value placementMetrics 
]

{ #category : 'metrics-accessing' }
WSCurrentMetrics class >> getSoftwareMetrics [ 
	
	^ self value softwareMetrics 
]

{ #category : 'metrics-accessing' }
WSCurrentMetrics class >> getTilesetMetrics [ 
	
	^ self value tilesetMetrics 
]
