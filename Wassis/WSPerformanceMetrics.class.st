"
Time metrics
"
Class {
	#name : 'WSPerformanceMetrics',
	#superclass : 'WSAbstractMetrics',
	#instVars : [
		'mdsTime',
		'wfcTime',
		'visualizationTime',
		'solverTotalTime',
		'totalTime',
		'wastedTime'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'accessing' }
WSPerformanceMetrics >> mdsTime [

	^ mdsTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> mdsTime: anObject [

	mdsTime := anObject
]

{ #category : 'accessing' }
WSPerformanceMetrics >> solverTotalTime [

	^ solverTotalTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> solverTotalTime: anObject [

	solverTotalTime := anObject
]

{ #category : 'accessing' }
WSPerformanceMetrics >> totalTime [

	^ totalTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> totalTime: anObject [

	totalTime := anObject
]

{ #category : 'accessing' }
WSPerformanceMetrics >> visualizationTime [

	^ visualizationTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> visualizationTime: anObject [

	visualizationTime := anObject
]

{ #category : 'accessing' }
WSPerformanceMetrics >> wastedTime [

	^ wastedTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> wastedTime: anObject [

	wastedTime := anObject
]

{ #category : 'accessing' }
WSPerformanceMetrics >> wfcTime [

	^ wfcTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> wfcTime: anObject [

	wfcTime := anObject
]
