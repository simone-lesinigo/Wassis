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
		'weightDifferencePercentage',
		'sameGraphRetriesInput',
		'sameClassPlacingRetriesInput',
		'sameGridSizeRetriesInput'
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
		spacing: 20;

		add: (SpBoxLayout newVertical
			spacing: 5;
			add: (self newLabel label: 'General Configuration') expand: false;
			add: (SpBoxLayout newHorizontal
				spacing: 15;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Heap Type:') expand: false;
					add: heapTypeDropList expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Class Placing Order:') expand: false;
					add: classPlacingDropList expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Minimum Class Distance:') expand: false;
					add: gridSafetyInput expand: false;
					yourself) expand: false;

				yourself) expand: false;
			yourself) expand: false;

		add: (SpBoxLayout newVertical
			spacing: 5;
			add: (self newLabel label: 'Path Configuration') expand: false;
			add: (SpBoxLayout newHorizontal
				spacing: 15;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Select a Strategy:') expand: false;
					add: pathTargetDropList expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Path Boost:') expand: false;
					add: pathBoostInput expand: false;
					yourself) expand: false;

				add: SpBoxLayout new;

				yourself) expand: false;
			yourself) expand: false;

		add: (SpBoxLayout newVertical
			spacing: 5;
			add: (self newLabel label: 'Tile Weights') expand: false;
			add: (SpBoxLayout newHorizontal
				spacing: 15;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Empty Tile:') expand: false;
					add: emptyTileWeightInput expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Straight Tile:') expand: false;
					add: straightTileWeightInput expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Corner Tile:') expand: false;
					add: cornerTileWeightInput expand: false;
					yourself) expand: false;

				yourself) expand: false;
			yourself) expand: false;

		add: (SpBoxLayout newVertical
			spacing: 5;
			add: (self newLabel label: 'Backtracking Configuration') expand: false;
			add: (SpBoxLayout newHorizontal
				spacing: 15;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Same Graph Retries:') expand: false;
					add: sameGraphRetriesInput expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Same Class Placing Retries:') expand: false;
					add: sameClassPlacingRetriesInput expand: false;
					yourself) expand: false;

				add: (SpBoxLayout newVertical
					add: (self newLabel label: 'Same Grid Size Retries:') expand: false;
					add: sameGridSizeRetriesInput expand: false;
					yourself) expand: false;

				yourself) expand: false;
			add: (self newLabel label: 'Select a Strategy:') expand: false;
			add: (SpBoxLayout newHorizontal
				add: backtrackingDropList expand: false;
				add: SpBoxLayout new;
				yourself) expand: false;
			
			add: dynamicStrategyContainer;
			
			yourself) expand: true;

		yourself
]

{ #category : 'initialization' }
WSConfigPresenter >> initializeDialogWindow: aDialogPresenter [

	super initializeWindow: aDialogPresenter.
	aDialogPresenter
		title: 'Wassis Configuration Settings';
		initialExtent: 550 @ 500;
		addButton: 'Cancel' do: [ :dialog | dialog close ];
		addButton: 'Save' do: [ :dialog | 
			self saveConfiguration.
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
			WSRandomClassPlacingOrder.
			WSMinConnectionFirstClassPlacingOrder.
			WSMaxConnectionFirstClassPlacingOrder.
			WSBFSMinClassPlacingOrder.
			WSBFSMaxClassPlacingOrder
		};
		display: [ :aClass | self labelForClassPlacingStrategy: aClass ];
		selectItem: WSConfig classPlacingOrder class;
		yourself.

	pathTargetDropList := self newDropList
		items: {
			WSClosestExitPathTargetStrategy.
			WSCentroidPathTargetStrategy.
			WSNonePathTargetStrategy
		};
		display: [ :aClass | self labelForPathTargetStrategy: aClass ];
		selectItem: WSConfig pathTargetStrategy class;
		yourself.

	pathBoostInput := self newNumberInput
		number: WSConfig pathBoost.

	gridSafetyInput := self newNumberInput
		number: WS2DRectangularGridConfig gridSafetyMooreRadius.

	emptyTileWeightInput := self newNumberInput
		number: WSConfig emptyTileWeight.

	straightTileWeightInput := self newNumberInput
		number: WS2DRectangularGridConfig straightTileWeight.

	cornerTileWeightInput := self newNumberInput
		number: WS2DRectangularGridConfig cornerTileWeight.
		
	sameGraphRetriesInput := self newNumberInput
		number: WSBacktrackingConfig maxNumberOfBacktrackPerGraph .

	sameClassPlacingRetriesInput := self newNumberInput
		number: WSBacktrackingConfig maxRetriesForSameClassPlacement.

	sameGridSizeRetriesInput := self newNumberInput
		number: WSBacktrackingConfig maxRegenerationsPerGridSize.

	backtrackingDropList := self newDropList
		items: {
			WSFixedStepsBacktracking.
			WSNumerousTilesBacktracking.
			WSPercentageBacktracking.
			WSSimilarWeightBacktracking.
			WSRestartFromScratchBacktracking
		};
		display: [ :aClass | self labelForBacktrackingStrategy: aClass ];
		selectItem: WSBacktrackingConfig backtrackingStrategy;
		yourself.

	fixedStepsInput := self newNumberInput
		number: WSFixedStepsBacktrackingConfig numberOfFixedSteps.

	numerousTilesInput := self newNumberInput
		number: WSNumerousTilesBacktrackingConfig tileCountThreshold.

	percentageInput := self newNumberInput
		number: WSPercentageBacktrackingConfig percentage.

	minSimilarTilesPercentage := self newNumberInput
		number: WSSimilarWeightBacktrackingConfig minSimilarTilesPercentage.

	weightDifferencePercentage := self newNumberInput
		number: WSSimilarWeightBacktrackingConfig weightDifferencePercentage.

	dynamicStrategyContainer := self newPresenter.

	backtrackingDropList
		whenSelectedItemChangedDo: [ :newStrategy |
			self updateDynamicConfigurationFor: newStrategy ].

	self updateDynamicConfigurationFor:
		backtrackingDropList selectedItem
]

{ #category : 'keymapping' }
WSConfigPresenter >> keyForBacktrackingStrategy: aClass [

	| map |
	map := Dictionary new
		at: WSFixedStepsBacktracking put: 'fixedSteps';
		at: WSNumerousTilesBacktracking put: 'numerousTile';
		at: WSPercentageBacktracking put: 'percentage';
		at: WSSimilarWeightBacktracking put: 'similarWeight';
		at: WSRestartFromScratchBacktracking put: 'restart';
		yourself.
	^ map at: aClass
]

{ #category : 'keymapping' }
WSConfigPresenter >> keyForClassPlacingStrategy: aClass [

	| map |
	map := Dictionary new
		at: WSRandomClassPlacingOrder put: 'random';
		at: WSMinConnectionFirstClassPlacingOrder put: 'minConnectionFirst';
		at: WSMaxConnectionFirstClassPlacingOrder put: 'maxConnectionFirst';
		at: WSBFSMinClassPlacingOrder put: 'BFSmin';
		at: WSBFSMaxClassPlacingOrder put: 'BFSmax';
		yourself.
	^ map at: aClass
]

{ #category : 'keymapping' }
WSConfigPresenter >> keyForPathTargetStrategy: aClass [

	| map |
	map := Dictionary new
		at: WSCentroidPathTargetStrategy put: 'centroid';
		at: WSClosestPathTargetStrategy put: 'closest';
		at: WSClosestExitPathTargetStrategy put: 'closest-exit';
		at: WSNonePathTargetStrategy put: 'none';
		yourself.
	^ map at: aClass
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

{ #category : 'saving' }
WSConfigPresenter >> saveConfiguration [

	| configDict |
	configDict := Dictionary new.

	configDict at: 'heapType' put: heapTypeDropList selectedItem.
	configDict at: 'classPlacingOrder' put: (self keyForClassPlacingStrategy: classPlacingDropList selectedItem).
	configDict at: 'pathTargetStrategy' put: (self keyForPathTargetStrategy: pathTargetDropList selectedItem).
	configDict at: 'pathBoost' put: pathBoostInput number.

	configDict at: 'emptyTileWeight' put: emptyTileWeightInput number.
	configDict at: 'gridSafetyMooreRadius' put: gridSafetyInput number.
	configDict at: 'straightTilesWeight' put: straightTileWeightInput number.
	configDict at: 'cornerTilesWeight' put: cornerTileWeightInput number.

	configDict at: 'backtrackingStrategy' put: (self keyForBacktrackingStrategy: backtrackingDropList selectedItem).
	configDict at: 'numberOfFixedSteps' put: fixedStepsInput number.
	configDict at: 'tileCountThreshold' put: numerousTilesInput number.
	configDict at: 'percentage' put: percentageInput number.
	configDict at: 'minSimilarTilesPercentage' put: minSimilarTilesPercentage number.
	configDict at: 'weightDifferencePercentage' put: weightDifferencePercentage number.

	WSConfig saveConfiguration: configDict
]

{ #category : 'updating' }
WSConfigPresenter >> updateDynamicConfigurationFor: aStrategy [

	| newLayout |

	newLayout := SpBoxLayout newVertical
		spacing: 0;
		yourself.

	aStrategy = WSFixedStepsBacktracking ifTrue: [
		newLayout
			add: (self newLabel label: 'Number of Steps:') expand: false;
			add: fixedStepsInput expand: false ].

	aStrategy = WSNumerousTilesBacktracking ifTrue: [
		newLayout
			add: (self newLabel label: 'Tile Threshold:') expand: false;
			add: numerousTilesInput expand: false ].

	aStrategy = WSPercentageBacktracking ifTrue: [
		newLayout
			add: (self newLabel label: 'Backtracking Percentage (0 - 100):') expand: false;
			add: percentageInput expand: false ].

	aStrategy = WSSimilarWeightBacktracking ifTrue: [
		newLayout add: (SpBoxLayout newHorizontal
			spacing: 20;
			add: (SpBoxLayout newVertical
				add: (self newLabel label: 'Tile % to Consider:') expand: false;
				add: minSimilarTilesPercentage expand: false;
				yourself) expand: false;
			add: (SpBoxLayout newVertical
				add: (self newLabel label: 'Max % difference:') expand: false;
				add: weightDifferencePercentage expand: false;
				yourself) expand: false;
			yourself) expand: false ].

	dynamicStrategyContainer layout: newLayout
]
