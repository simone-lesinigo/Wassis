Class {
	#name : 'WSPlacementMetricsPresenter',
	#superclass : 'WSMetricPresenter',
	#instVars : [
		'avgTable',
		'pairsTable'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'layout' }
WSPlacementMetricsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 10;
		  add: (self newLabel label: 'Avg Connected Class Distance' asText) expand: false;
		  add: avgTable height: 200;
		  add: (self newLabel label: 'Class Distances on grid' asText) expand: false;
		  add: pairsTable expand: true;
		  yourself
]

{ #category : 'initialization' }
WSPlacementMetricsPresenter >> initializePresenters [

	avgTable := self newTable.
	avgTable
		addColumn: (SpStringTableColumn new
			title: 'Class';
			evaluated: [ :row | row first ];
			sortFunction: [ :row | row first ] ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Avg Distance from Connected Classes';
			evaluated: [ :row | row second printShowingDecimalPlaces: 1 ];
			sortFunction: [ :row | row second ] ascending;
			yourself);
		beResizable;
		showColumnHeaders.
		
	pairsTable := self newTable.
	pairsTable
		addColumn: (SpStringTableColumn new
			title: 'Source Class';
			evaluated: [ :row | row first ];
			sortFunction: [ :row | row first ] ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Destination Class';
			evaluated: [ :row | row second ];
			sortFunction: [ :row | row second ] ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Distance';
			evaluated: [ :row | row third printString ];
			sortFunction: [ :row | row third ] ascending;
			yourself);
		beResizable;
		showColumnHeaders.
]

{ #category : 'as yet unclassified' }
WSPlacementMetricsPresenter >> updateAvgTable [

	| avgDict rows overall |
	avgDict := Metrics placementMetrics avgConnectedClassesDistance.
	rows := avgDict associations
		        collect: [ :assoc | Array with: assoc key name with: assoc value asFloat ].
	overall := avgDict isEmpty
		           ifTrue: [ 0 ]
		           ifFalse: [ (avgDict values inject: 0 into: [ :sum :v | sum + v ]) / avgDict size asFloat ].
	avgTable items: rows asOrderedCollection , { Array with: 'Average Distance' with: overall asFloat }
]

{ #category : 'as yet unclassified' }
WSPlacementMetricsPresenter >> updatePairsTable [

	| classDistances rows |
	classDistances := Metrics placementMetrics classDistances.
	rows := classDistances associations
		        collect: [ :assoc |
			        Array
				        with: assoc key key name
				        with: assoc key value name
				        with: assoc value ].
	pairsTable items: rows asOrderedCollection
]

{ #category : 'initialization' }
WSPlacementMetricsPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].
	self updateAvgTable.
	self updatePairsTable.
]
