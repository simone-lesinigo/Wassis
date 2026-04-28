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
		'wastedTime',
		'totalNumberOfTries',
		'pathReificationTime'
	],
	#category : 'Wassis-Metrics',
	#package : 'Wassis',
	#tag : 'Metrics'
}

{ #category : 'initialization' }
WSPerformanceMetrics >> initialize [ 
	
	super initialize.
	self totalNumberOfTries: 1
]

{ #category : 'accessing' }
WSPerformanceMetrics >> mdsTime [

	^ mdsTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> mdsTime: anObject [

	mdsTime := anObject
]

{ #category : 'accessing' }
WSPerformanceMetrics >> pathReificationTime [

	^ pathReificationTime
]

{ #category : 'accessing' }
WSPerformanceMetrics >> pathReificationTime: anObject [

	pathReificationTime := anObject
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
WSPerformanceMetrics >> totalNumberOfTries [

	^ totalNumberOfTries
]

{ #category : 'accessing' }
WSPerformanceMetrics >> totalNumberOfTries: anObject [

	totalNumberOfTries := anObject
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
