"
Window to change configs
"
Class {
	#name : 'WSConfigPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'heapTypeDropList',
		'classPlacingDropList',
		'pathTargetDropList',
		'pathBoostInput',
		'emptyTileWeightInput',
		'straightTileWeightInput',
		'cornerTileWeightInput',
		'gridSafetyInput',
		'backtrackingDropList',
		'dynamicStrategyContainer',
		'fixedStepsInput',
		'numerousTilesInput',
		'percentageInput',
		'stepsGroup',
		'percentageGroup',
		'tilesGroup',
		'similarWeightGroup',
		'minSimilarTilesPercentage',
		'weightDifferencePercentage'
	],
	#category : 'Wassis-Visualization-WorldMenu',
	#package : 'Wassis-Visualization',
	#tag : 'WorldMenu'
}

{ #category : 'instance creation' }
WSConfigPresenter class >> open [

	^ self new openModal
]

{ #category : 'layout' }
WSConfigPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: (self newLabel label: 'General Configuration') expand: false;
		  add: (SpGridLayout new
				   add: (self newLabel label: 'Heap Type:') atPoint: 1 @ 1;
				   add: heapTypeDropList atPoint: 1 @ 2;
				   add: (self newLabel label: 'Class Placing Order:') atPoint: 2 @ 1;
				   add: classPlacingDropList atPoint: 2 @ 2;
				   add: (self newLabel label: 'Minimum Class Distance:') atPoint: 1 @ 3;
				   add: gridSafetyInput atPoint: 1 @ 4;
				   yourself);
		  spacing: 40;
		  add: (self newLabel label: 'Path Configuration') expand: false;
		  add: (SpGridLayout new
				   add: (self newLabel label: 'Path Target Strategy:') atPoint: 1 @ 1;
				   add: pathTargetDropList atPoint: 1 @ 2;
				   add: (self newLabel label: 'Path Boost:') atPoint: 2 @ 1;
				   add: pathBoostInput atPoint: 2 @ 2;
				   yourself);
		  spacing: 10;
		  add: (self newLabel label: 'Tile Weights') expand: false;
		  add: (SpGridLayout new
				   add: (self newLabel label: 'Empty Tile:') atPoint: 1 @ 1;
				   add: emptyTileWeightInput atPoint: 1 @ 2;
					add: (self newLabel label: 'Straight Tile:') atPoint: 2 @ 1;
				   add: straightTileWeightInput atPoint: 2 @ 2;
					add: (self newLabel label: 'Corner Tile:') atPoint: 1 @ 3;
				   add: cornerTileWeightInput atPoint: 1 @ 4;
				   yourself);
			add: (self newLabel label: 'Backtracking Strategy') expand: false;
			add: backtrackingDropList expand: false;
			add: dynamicStrategyContainer expand: false;
			yourself
]

{ #category : 'initialization' }
WSConfigPresenter >> initializeDialogWindow: aDialogPresenter [

	super initializeWindow:aDialogPresenter.
	aDialogPresenter
		title: 'Wassis Configuration Settings';
		initialExtent: 450 @ 800;
		addButton: 'Cancel' do: [ :dialog | dialog close ];
		addButton: 'Save' do: [ :dialog | 
			"self saveConfiguration."
			dialog close ]
]

{ #category : 'initialization' }
WSConfigPresenter >> initializePresenters [
	super initializePresenters.

	heapTypeDropList := self newDropList
		items: #('minHeap' 'maxHeap');
		selectItem: WSConfig heapType;
		yourself.

	classPlacingDropList := self newDropList
		items: { 
			WSRandomClassPlacingOrder . 
			WSMinConnectionFirstClassPlacingOrder . 
			WSMaxConnectionFirstClassPlacingOrder . 
			WSBFSMinClassPlacingOrder . 
			WSBFSMaxClassPlacingOrder 
		};
		display: [ :aClass | self labelForClassPlacingStrategy: aClass ];
		selectItem: WSConfig classPlacingOrder class;
		yourself.

	pathTargetDropList := self newDropList
		items: { 
			WSClosestExitPathTargetStrategy . 
			WSCentroidPathTargetStrategy . 
			WSNonePathTargetStrategy 
		};
		display: [ :aClass | self labelForPathTargetStrategy: aClass ];
		selectItem: WSConfig pathTargetStrategy class;
		yourself.

	pathBoostInput := self newNumberInput number: WSConfig pathBoost.
	emptyTileWeightInput := self newNumberInput number: WSConfig emptyTileWeight.
	straightTileWeightInput := self newNumberInput number: WS2DRectangularGridConfig straightTileWeight.
	cornerTileWeightInput := self newNumberInput number: WS2DRectangularGridConfig cornerTileWeight.
	gridSafetyInput := self newNumberInput number: WS2DRectangularGridConfig gridSafetyMooreRadius.

	backtrackingDropList := self newDropList
		items: { 
			WSFixedStepsBacktracking . 
			WSNumerousTilesBacktracking . 
			WSPercentageBacktracking . 
			WSSimilarWeightBacktracking . 
			WSRestartFromScratchBacktracking 
		};
		display: [ :aClass | self labelForBacktrackingStrategy: aClass ];
		selectItem: WSBacktrackingConfig backtrackingStrategy;
		yourself.
	
	fixedStepsInput := self newNumberInput number: WSFixedStepsBacktrackingConfig numberOfFixedSteps.
	numerousTilesInput := self newNumberInput number: WSNumerousTilesBacktrackingConfig tileCountThreshold.
	percentageInput := self newNumberInput number: WSPercentageBacktrackingConfig percentage.
	minSimilarTilesPercentage := self newNumberInput number: WSSimilarWeightBacktrackingConfig minSimilarTilesPercentage.
	weightDifferencePercentage := self newNumberInput number: WSSimilarWeightBacktrackingConfig weightDifferencePercentage.

	stepsGroup := self newPresenter
		layout: (SpBoxLayout newVertical
			add: (self newLabel label: 'Number of Steps:') expand: false;
			add: fixedStepsInput expand: false;
			yourself);
		yourself. 

	tilesGroup := self newPresenter
		layout: (SpBoxLayout newVertical
			add: (self newLabel label: 'Tile Threshold:') expand: false;
			add: numerousTilesInput expand: false;
			yourself);
		yourself.

	percentageGroup := self newPresenter
		layout: (SpBoxLayout newVertical
			add: (self newLabel label: 'Backtracking Percentage (0 - 100):') expand: false;
			add: percentageInput expand: false;
			yourself);
		yourself.
		
similarWeightGroup := self newPresenter
	layout: (SpBoxLayout newHorizontal
		spacing: 10;
		add: (SpBoxLayout newVertical
			add: (self newLabel label: 'Tile to Consider:') expand: false;
			add: minSimilarTilesPercentage expand: false;
			yourself);
		add: (SpBoxLayout newVertical
			add: (self newLabel label: 'Max % difference:') expand: false;
			add: weightDifferencePercentage expand: false;
			yourself);
		yourself);
	yourself.
	
   dynamicStrategyContainer := self newPresenter.
	dynamicStrategyContainer layout: SpBoxLayout newVertical.

	backtrackingDropList whenSelectedItemChangedDo: [ :newStrategy | 
		self updateDynamicConfigurationFor: newStrategy ].

	self updateDynamicConfigurationFor: backtrackingDropList selectedItem

]

{ #category : 'label' }
WSConfigPresenter >> labelForBacktrackingStrategy: aClass [

	| labels |
	labels := { 
		WSFixedStepsBacktracking -> 'Fixed Steps'.
		WSNumerousTilesBacktracking -> 'Numerous Tiles'.
		WSPercentageBacktracking -> 'Percentage'.
		WSSimilarWeightBacktracking -> 'Similar Weight'.
		WSRestartFromScratchBacktracking -> 'Restart from Scratch'
	} asDictionary.
	
	^ labels at: aClass ifAbsent: [ aClass name ]
]

{ #category : 'label' }
WSConfigPresenter >> labelForClassPlacingStrategy: aClass [

	| labels |
	labels := { 
		WSRandomClassPlacingOrder -> 'Random'.
		WSMinConnectionFirstClassPlacingOrder -> 'Min Connection First'.
		WSMaxConnectionFirstClassPlacingOrder -> 'Max Connection First'.
		WSBFSMinClassPlacingOrder -> 'BFS (Min Connections)'.
		WSBFSMaxClassPlacingOrder -> 'BFS (Max Connections)'
	} asDictionary.

	^ labels at: aClass ifAbsent: [ aClass name ]
]

{ #category : 'label' }
WSConfigPresenter >> labelForPathTargetStrategy: aClass [

	| labels |
	labels := { 
		WSClosestExitPathTargetStrategy -> 'Closest Exit'.
		WSCentroidPathTargetStrategy -> 'Centroid'.
		WSNonePathTargetStrategy -> 'None'
	} asDictionary.

	^ labels at: aClass ifAbsent: [ aClass name ]
]

{ #category : 'updating' }
WSConfigPresenter >> updateDynamicConfigurationFor: aStrategy [
	| newLayout |
	newLayout := SpBoxLayout newVertical spacing: 5.

	aStrategy = WSFixedStepsBacktracking ifTrue: [ 
		newLayout add: stepsGroup expand: false ].

	aStrategy = WSNumerousTilesBacktracking ifTrue: [ 
		newLayout add: tilesGroup expand: false ].

	aStrategy = WSPercentageBacktracking ifTrue: [ 
		newLayout add: percentageGroup expand: false ].
	
	aStrategy = WSSimilarWeightBacktracking ifTrue: [ 
		newLayout add: similarWeightGroup expand: false ].

	dynamicStrategyContainer layout: newLayout
]
