Class {
	#name : 'WSGraphMetricsPresenter',
	#superclass : 'WSMetricPresenter',
	#instVars : [
		'table',
		'bar'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'layout' }
WSGraphMetricsPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  spacing: 15;
		  add: table expand: true;
		  add: bar expand: true;
		  yourself
]

{ #category : 'initialization' }
WSGraphMetricsPresenter >> initializePresenters [

	table := self newTable.
	(table
		addColumn: (SpStringTableColumn new title: 'Metric'; evaluated: [ :e | e key ]; yourself);
		addColumn: (SpStringTableColumn new title: 'Value'; evaluated: [ :e | e value ]; yourself); yourself)
		showColumnHeaders.
	bar := self instantiate: WSStackedBarPresenter.
]

{ #category : 'initialization' }
WSGraphMetricsPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].
	table items: {
		'Dimension' -> Metrics graphMetrics dimension printString.
		'Total Nodes' -> Metrics graphMetrics totalNumberOfNodes printString.
		'Class Nodes' -> Metrics graphMetrics numberOfClassNodes printString.
		'Path Nodes' -> Metrics graphMetrics numberOfPathNodes printString.
		'Empty Nodes' -> Metrics graphMetrics numberOfEmptyNodes printString.
		'Overlaps' -> Metrics graphMetrics numberOfOverlaps printString
	}.
	bar updatePresenter
]
