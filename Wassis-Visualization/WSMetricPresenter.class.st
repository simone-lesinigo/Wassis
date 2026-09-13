Class {
	#name : 'WSMetricPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'graphPage',
		'performancePage',
		'placementPage',
		'softwarePage'
	],
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

{ #category : 'layout' }
WSMetricPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: notebook;
		  yourself
]

{ #category : 'initialization' }
WSMetricPresenter >> initializePresenters [

	notebook := self newNotebook.
	graphPage := self instantiate: WSGraphMetricsPresenter.
	performancePage := self instantiate: WSPerformanceMetricsPresenter.
	placementPage := self instantiate: WSPlacementMetricsPresenter.
	softwarePage := self instantiate: WSSoftwareSystemPresenter.

	notebook
		addPage: (SpNotebookPage title: 'Graph' provider: [ graphPage ]);
		addPage: (SpNotebookPage title: 'Performance' provider: [ performancePage ]);
		addPage: (SpNotebookPage title: 'Placement' provider: [ placementPage ]);
		addPage: (SpNotebookPage title: 'System' provider: [ softwarePage ]).
]

{ #category : 'initialization' }
WSMetricPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Wassis - Metrics';
		initialExtent: 700 @ 600
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

{ #category : 'initialization' }
WSMetricPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].
	graphPage ifNotNil: [ graphPage updatePresenter ].
	performancePage ifNotNil: [ performancePage updatePresenter ].
	placementPage ifNotNil: [ placementPage updatePresenter ].
	softwarePage ifNotNil: [ softwarePage updatePresenter ]
]
