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
		addColumn: (SpStringTableColumn new title: 'Class'; evaluated: [ :e | e key ]; yourself);
		addColumn: (SpStringTableColumn new title: 'Avg Distance from Connected Classes'; evaluated: [ :e | e value ]; yourself);
		beResizable;
		showColumnHeaders.

	pairsTable := self newTable.
	pairsTable
		addColumn: (SpStringTableColumn new title: 'Class A'; evaluated: [ :row | row first ]; yourself);
		addColumn: (SpStringTableColumn new title: 'Class B'; evaluated: [ :row | row second ]; yourself);
		addColumn: (SpStringTableColumn new title: 'Distance'; evaluated: [ :row | row third ]; yourself);
		beResizable;
		showColumnHeaders.
]

{ #category : 'as yet unclassified' }
WSPlacementMetricsPresenter >> updateAvgTable [

	| avgDict rows overall |
	avgDict := Metrics placementMetrics avgConnectedClassesDistance.
	rows := (avgDict associations asSortedCollection: [ :a :b | a key name <= b key name ])
		        collect: [ :assoc | assoc key name -> (assoc value asFloat printShowingDecimalPlaces: 1) ].
	overall := avgDict isEmpty
		           ifTrue: [ 0 ]
		           ifFalse: [ (avgDict values inject: 0 into: [ :sum :v | sum + v ]) / avgDict size asFloat ].
	avgTable items: rows asOrderedCollection , { 'Average' -> (overall asFloat printShowingDecimalPlaces: 1) }
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
				        with: assoc value printString ].
	pairsTable items: (rows asSortedCollection: [ :a :b | a third asNumber >= b third asNumber ]) asOrderedCollection
]

{ #category : 'initialization' }
WSPlacementMetricsPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].
	self updateAvgTable.
	self updatePairsTable.
]
