"
Metrics about the paths
"
Class {
	#name : 'WSPathMetrics',
	#superclass : 'WSAbstractMetrics',
	#instVars : [
		'totalNumberOfPaths',
		'numberOfMergingPaths',
		'numberOfDirectPaths'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSPathMetrics >> numberOfDirectPaths [

	^ numberOfDirectPaths
]

{ #category : 'accessing' }
WSPathMetrics >> numberOfDirectPaths: anObject [

	numberOfDirectPaths := anObject
]

{ #category : 'accessing' }
WSPathMetrics >> numberOfMergingPaths [

	^ numberOfMergingPaths
]

{ #category : 'accessing' }
WSPathMetrics >> numberOfMergingPaths: anObject [

	numberOfMergingPaths := anObject
]

{ #category : 'accessing' }
WSPathMetrics >> totalNumberOfPaths [

	^ totalNumberOfPaths
]

{ #category : 'accessing' }
WSPathMetrics >> totalNumberOfPaths: anObject [

	totalNumberOfPaths := anObject
]
