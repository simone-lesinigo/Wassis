"
Metrics about the graph
"
Class {
	#name : 'WSGraphMetrics',
	#superclass : 'WSAbstractMetrics',
	#instVars : [
		'totalNumberOfNodes',
		'numberOfPathNodes',
		'numberOfClassNodes',
		'numberOfEmptyNodes',
		'dimension'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSGraphMetrics >> dimension [

	^ dimension
]

{ #category : 'accessing' }
WSGraphMetrics >> dimension: anObject [

	dimension := anObject
]

{ #category : 'accessing' }
WSGraphMetrics >> numberOfClassNodes [

	^ numberOfClassNodes
]

{ #category : 'accessing' }
WSGraphMetrics >> numberOfClassNodes: anObject [

	numberOfClassNodes := anObject
]

{ #category : 'accessing' }
WSGraphMetrics >> numberOfEmptyNodes [

	^ numberOfEmptyNodes
]

{ #category : 'accessing' }
WSGraphMetrics >> numberOfEmptyNodes: anObject [

	numberOfEmptyNodes := anObject
]

{ #category : 'accessing' }
WSGraphMetrics >> numberOfPathNodes [

	^ numberOfPathNodes
]

{ #category : 'accessing' }
WSGraphMetrics >> numberOfPathNodes: anObject [

	numberOfPathNodes := anObject
]

{ #category : 'accessing' }
WSGraphMetrics >> totalNumberOfNodes [

	^ totalNumberOfNodes
]

{ #category : 'accessing' }
WSGraphMetrics >> totalNumberOfNodes: anObject [

	totalNumberOfNodes := anObject
]
