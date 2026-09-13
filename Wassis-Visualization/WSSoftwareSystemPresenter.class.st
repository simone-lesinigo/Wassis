Class {
	#name : 'WSSoftwareSystemPresenter',
	#superclass : 'WSMetricPresenter',
	#instVars : [
		'numberOfClassesLabel',
		'avgConnectionsLabel',
		'connectionsTable'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'layout' }
WSSoftwareSystemPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 8;
		  add: (self newLabel label: 'Software System Metrics' asText) expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: (self newLabel label: 'Number of Classes:') expand: false;
				   add: numberOfClassesLabel expand: false;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: (self newLabel label: 'Avg Connections per Class:') expand: false;
				   add: avgConnectionsLabel expand: false;
				   yourself)
		  expand: false;
		  add: connectionsTable expand: true;
		  yourself
]

{ #category : 'initialization' }
WSSoftwareSystemPresenter >> initializePresenters [

	numberOfClassesLabel := self newLabel.
	avgConnectionsLabel := self newLabel.

	connectionsTable := self newTable.
	connectionsTable
		addColumn: (SpStringTableColumn new
			title: 'Class';
			evaluated: [ :row | row first ];
			sortFunction: [ :row | row first ] ascending;
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Connections';
			evaluated: [ :row | row second printString ];
			sortFunction: [ :row | row second ] ascending;
			yourself);
		beResizable;
		showColumnHeaders.
]

{ #category : 'as yet unclassified' }
WSSoftwareSystemPresenter >> updateConnectionsTable [

	| connectionsDict rows |
	connectionsDict := Metrics softwareMetrics numberOfConnectionsPerClass.
	rows := connectionsDict associations
		        collect: [ :assoc | Array with: assoc key name with: assoc value ].
	connectionsTable items: rows asOrderedCollection
]

{ #category : 'initialization' }
WSSoftwareSystemPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].
	self updateSummaryLabels.
	self updateConnectionsTable.
]

{ #category : 'as yet unclassified' }
WSSoftwareSystemPresenter >> updateSummaryLabels [

	numberOfClassesLabel label: Metrics softwareMetrics numberOfClasses printString.
	avgConnectionsLabel label: (Metrics softwareMetrics avgNumOfConnectionsPerClass asFloat printShowingDecimalPlaces: 1)
]
