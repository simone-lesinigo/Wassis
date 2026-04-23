"
Metrics about the software system that is being visualized
"
Class {
	#name : 'WSSoftwareMetrics',
	#superclass : 'WSMetrics',
	#instVars : [
		'numberOfClasses',
		'avgNumOfConnectionsPerClass',
		'numberOfConnectionsPerClass'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSSoftwareMetrics >> avgNumOfConnectionsPerClass [

	^ avgNumOfConnectionsPerClass
]

{ #category : 'accessing' }
WSSoftwareMetrics >> avgNumOfConnectionsPerClass: anObject [

	avgNumOfConnectionsPerClass := anObject
]

{ #category : 'initialization' }
WSSoftwareMetrics >> initialize [ 
	super initialize.
	self numberOfConnectionsPerClass: Dictionary new 
]

{ #category : 'accessing' }
WSSoftwareMetrics >> numberOfClasses [

	^ numberOfClasses
]

{ #category : 'accessing' }
WSSoftwareMetrics >> numberOfClasses: anObject [

	numberOfClasses := anObject
]

{ #category : 'accessing' }
WSSoftwareMetrics >> numberOfConnectionsPerClass [

	^ numberOfConnectionsPerClass
]

{ #category : 'accessing' }
WSSoftwareMetrics >> numberOfConnectionsPerClass: anObject [

	numberOfConnectionsPerClass := anObject
]
