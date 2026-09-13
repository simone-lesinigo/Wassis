Class {
	#name : 'WSMetricPresenter',
	#superclass : 'SpPresenter',
	#classVars : [
		'Metrics'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
WSMetricPresenter class >> openWithMetrics: aMetrics [

	^ (self on: aMetrics) open
]

{ #category : 'accessing - structure variables' }
WSMetricPresenter >> metrics [
	
	^ Metrics
]

{ #category : 'accessing - structure variables' }
WSMetricPresenter >> metrics: anObject [
	
	Metrics := anObject
]

{ #category : 'accessing - model' }
WSMetricPresenter >> setModelBeforeInitialization: aMetrics [

	Metrics := aMetrics
]
