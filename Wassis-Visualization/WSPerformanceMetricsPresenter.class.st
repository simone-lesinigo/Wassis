Class {
	#name : 'WSPerformanceMetricsPresenter',
	#superclass : 'WSMetricPresenter',
	#instVars : [
		'table'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'layout' }
WSPerformanceMetricsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 8;
		  add: table expand: true;
		  yourself
]

{ #category : 'initialization' }
WSPerformanceMetricsPresenter >> initializePresenters [

	table := self newTable.
	table
		addColumn: (SpStringTableColumn new
			title: 'Metric';
			evaluated: [ :each | each key ];
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Value';
			evaluated: [ :each | each value ];
			yourself);
		beResizable;
		showColumnHeaders.
]

{ #category : 'initialization' }
WSPerformanceMetricsPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].

	table items: {
		'Total Time' -> Metrics performanceMetrics totalTime humanReadablePrintString.
		'WFC Time' -> Metrics performanceMetrics wfcTime humanReadablePrintString.
		'Total Tries' -> Metrics performanceMetrics totalNumberOfTries printString
	}
]
