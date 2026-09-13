Class {
	#name : 'WSGraphMetricsPresenter',
	#superclass : 'WSMetricPresenter',
	#instVars : [
		'table'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'layout' }
WSGraphMetricsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 8;
		  add: (self newLabel label: 'Graph Metrics' asText) expand: false;
		  add: table expand: true;
		  yourself
]

{ #category : 'initialization' }
WSGraphMetricsPresenter >> initializePresenters [

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
		beResizable.
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
	}
]
