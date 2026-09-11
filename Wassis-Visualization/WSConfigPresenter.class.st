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
		'backtrackingDropList'
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
		  add: (self newLabel label: 'Tile Wieghts') expand: false;
		  add: (SpGridLayout new
				   add: (self newLabel label: 'Empty Tile:') atPoint: 1 @ 1;
				   add: emptyTileWeightInput atPoint: 1 @ 2;
					add: (self newLabel label: 'Straight Tile:') atPoint: 2 @ 1;
				   add: straightTileWeightInput atPoint: 2 @ 2;
					add: (self newLabel label: 'Corner Tile:') atPoint: 1 @ 3;
				   add: cornerTileWeightInput atPoint: 1 @ 4;
				   yourself);
			add: (self newLabel label: 'Backtracking Strategy') expand: false;
			add: backtrackingDropList expand: false
]

{ #category : 'initialization' }
WSConfigPresenter >> initializeDialogWindow: aDialogPresenter [

	super initializeWindow:aDialogPresenter.
	aDialogPresenter
		title: 'Wassis Configuration Settings';
		initialExtent: 450 @ 800;
		addButton: 'Cancel' do: [ :dialog | dialog close ];
		addButton: 'Save' do: [ :dialog | 
			self saveConfiguration.
			dialog close ]
]

{ #category : 'initialization' }
WSConfigPresenter >> initializePresenters [

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

	pathBoostInput := self newTextInput text: WSConfig pathBoost asString.

	emptyTileWeightInput := self newTextInput text:( WSConfig emptyTileWeight) asString.

	straightTileWeightInput := self newTextInput text: (WS2DRectangularGridConfig straightTileWeight) asString.

	cornerTileWeightInput := self newTextInput text: (WS2DRectangularGridConfig  cornerTileWeight) asString.

	gridSafetyInput := self newTextInput text: (WS2DRectangularGridConfig  gridSafetyMooreRadius) asString.

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
	| json file backtrackingNode topoNode rectNode tileNode |
	
	"1. Recuperiamo il JSON in memoria"
	json := WSConfig configFile.
	
	"2. Aggiorniamo i campi di base"
	json at: 'heapType' put: heapTypeDropList selectedItem.
	json at: 'classPlacingOrder' put: classPlacingDropList selectedItem.
	json at: 'pathTargetStrategy' put: pathTargetDropList selectedItem.
	json at: 'pathBoost' put: pathBoostInput number.
	
	"3. Aggiorniamo i campi annidati (creando i dizionari se per caso mancano)"
	(json at: 'WSTile' ifAbsentPut: [ Dictionary new ])
		at: 'emptyTileWeight' put: emptyTileWeightInput number.
		
	backtrackingNode := json at: 'WSBacktracking' ifAbsentPut: [ Dictionary new ].
	backtrackingNode at: 'backtrackingStrategy' put: backtrackingDropList selectedItem.
	
	topoNode := json at: 'WS2DGridTopology' ifAbsentPut: [ Dictionary new ].
	topoNode at: 'gridSafetyMooreRadius' put: gridSafetyInput number.
	
	rectNode := topoNode at: 'WS2DRectangularGridTopology' ifAbsentPut: [ Dictionary new ].
	tileNode := rectNode at: 'WS2DSquareTile' ifAbsentPut: [ Dictionary new ].
	
	tileNode at: 'straightTilesWeight' put: straightTileWeightInput number.
	tileNode at: 'cornerTilesWeight' put: cornerTileWeightInput number.
	
	"4. Scriviamo su file fisso"
	file := (WSObject resourcesRootPath / 'config.json') asFileReference.
	file writeStreamDo: [ :stream |
		(NeoJSONWriter on: stream)
			prettyPrint: true;
			nextPut: json ].
			
	"5. Pialliamo la cache di WSConfig per forzare la ricarica al prossimo avvio"
	WSConfig reset.
	
	UIManager default inform: 'Configuration saved successfully!'.
]
