"
Dialog for class selection
"
Class {
	#name : 'WSClassSelectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'selectedClass',
		'classLabel',
		'classIcon',
		'selectClassButton',
		'strategyDropList',
		'runButton',
		'configButton'
	],
	#category : 'Wassis-Visualization-WorldMenu',
	#package : 'Wassis-Visualization',
	#tag : 'WorldMenu'
}

{ #category : 'instance creation' }
WSClassSelectionPresenter class >> open [
	
	self new open
]

{ #category : 'layout' }
WSClassSelectionPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		spacing: 12;
		add: (SpBoxLayout newHorizontal
			spacing: 8;
			vAlignCenter;
			add: classIcon expand: false;
			add: classLabel expand: true;
			add: selectClassButton expand: false;
			yourself) expand: false;
		add: (SpBoxLayout newHorizontal
			spacing: 8;
			vAlignCenter;
			add: (self newLabel label: 'Strategy:') expand: false;
			add: strategyDropList expand: true;
			yourself) expand: false;
		add: (SpBoxLayout newHorizontal 
			spacing: 8;
			vAlignCenter;
			add: configButton expand: true;
			add: runButton expand: true;
			yourself) expand: false;
		yourself
]

{ #category : 'initialization' }
WSClassSelectionPresenter >> initializePresenters [
	selectedClass := nil.
	
	classIcon := self newImage
		image: (self iconNamed: #class);
		yourself.

	classLabel := self newLabel yourself.
		
	selectClassButton := SpButtonPresenter new.
	selectClassButton
		label: 'Search Class';
		iconName: #search;
		action: [ self selectClass ].

	strategyDropList := self newDropList
		items: { WSFullHierarchyCollector . WSSubclassesCollector . WSSuperclassesCollector };
		display: [ :aClass | self labelForStrategy: aClass ];
		selectIndex: 1;
		yourself.
		
	configButton := self newButton
		label: 'Config';
		iconName: #smallCogInitialState;
		action: [ WSConfigPresenter open ];
		yourself.

	runButton := self newButton
		label: 'Run Solver';
		iconName: #play;
		action: [ self runVisualization ];
		yourself.
	
	self update.
]

{ #category : 'initialization' }
WSClassSelectionPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Pharo Hierarchy Visualization';
		initialExtent: 420 @ 150;
		beNotResizable
]

{ #category : 'label' }
WSClassSelectionPresenter >> labelForStrategy: aClass [

	aClass = WSFullHierarchyCollector ifTrue: [ ^ 'Full Hierarchy' ].
	aClass = WSSubclassesCollector ifTrue: [ ^ 'Subclasses Only' ].
	aClass = WSSuperclassesCollector ifTrue: [ ^ 'Superclasses Only' ].
	
	^ aClass name
]

{ #category : 'running' }
WSClassSelectionPresenter >> runVisualization [
	| swSystem confirm adaptiveSolver |
	
	selectedClass ifNil: [ 
		UIManager default inform: 'No class selected.'.
		^ self ].

	swSystem := WSSoftwareSystem usingStrategy: (strategyDropList selectedItem withOriginClass: selectedClass).

	confirm := UIManager default confirm: 
		('Found ', swSystem classes size asString, ' classes for ', selectedClass name, '.', String cr, 'Do you want to run WFC?').
	confirm ifFalse: [ ^ self ].

	WSWorldUI isTranscriptOpen ifFalse: [ Transcript open ].

	adaptiveSolver := WSAdaptive2DGridSolver 
		withTopology: WS2DRectangularGridTopology 
		andSwSystem: swSystem.

	adaptiveSolver run.
	self window close.
]

{ #category : 'selection' }
WSClassSelectionPresenter >> selectClass [
	"Open a dialog to select a Pharo class"

	| dialog presenter |
	presenter := self newFilteringList.
	presenter 
		items: (Smalltalk globals allClasses sorted: [ :a :b | a name < b name ]);
		display: [ :c | c name ].

	dialog := presenter asModalWindow.
	dialog title: 'Select a Pharo Class'; open.

	dialog isOk ifTrue: [ 
		presenter selectedItem ifNotNil: [ :pickedClass | 
			selectedClass := pickedClass.
			self update ] ]
]

{ #category : 'update' }
WSClassSelectionPresenter >> update [ 
	
	self updateClassLabel.
	self updateRunButtonState.
]

{ #category : 'update' }
WSClassSelectionPresenter >> updateClassLabel [

	classLabel label: 'Class: ', (selectedClass 
		ifNil: [ 'No class selected' ] 
		ifNotNil: [ :c | c name ]).
]

{ #category : 'update' }
WSClassSelectionPresenter >> updateRunButtonState [
	
	runButton ifNotNil: [ runButton enabled: selectedClass isNotNil ]
	
]
