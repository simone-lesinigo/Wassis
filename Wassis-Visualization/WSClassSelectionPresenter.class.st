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
		'configButton',
		'instanceCountInput'
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
			add: (self newLabel label: 'N of Instances:') expand: false;
			add: instanceCountInput expand: true;
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
		
	instanceCountInput := self newNumberInput number: 1; yourself.
	
	self update.
]

{ #category : 'initialization' }
WSClassSelectionPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Pharo Hierarchy Visualization';
		initialExtent: 420 @ 200;
		beNotResizable
]

{ #category : 'label' }
WSClassSelectionPresenter >> labelForStrategy: aClass [

	aClass = WSFullHierarchyCollector ifTrue: [ ^ 'Full Hierarchy' ].
	aClass = WSSubclassesCollector ifTrue: [ ^ 'Subclasses Only' ].
	aClass = WSSuperclassesCollector ifTrue: [ ^ 'Superclasses Only' ].
	
	^ aClass name
]

{ #category : 'as yet unclassified' }
WSClassSelectionPresenter >> runFromPharoScriptPath [

	^ WSObject resourcesRootPath / 'script' / 'runFromPharo.sh'
]

{ #category : 'running' }
WSClassSelectionPresenter >> runInImage: swSystem [
	| adaptiveSolver |

	WSWorldUI isTranscriptOpen ifFalse: [ Transcript open ].

	adaptiveSolver := WSAdaptive2DGridSolver 
		withTopology: WS2DRectangularGridTopology 
		andSwSystem: swSystem.

	adaptiveSolver run.
]

{ #category : 'running' }
WSClassSelectionPresenter >> runInParallel: instances [
	| solverSource solverFile |

	solverSource := self solverSourceFor: selectedClass strategy: strategyDropList selectedItem.
	
	solverFile := self solverScriptPath asFileReference.
	solverFile ensureDelete.
	solverFile writeStreamDo: [ :stream |
		stream nextPutAll: solverSource ].

	OSSUnixSubprocess new
		command: '/bin/bash';
		arguments: { 
			self runFromPharoScriptPath asFileReference fullName . 
			instances printString .
			Smalltalk vm binary asFileReference fullName .
			Smalltalk image imagePath asFileReference fullName .
			solverFile fullName
		};
		run.
]

{ #category : 'running' }
WSClassSelectionPresenter >> runVisualization [
	| swSystem confirm instances |

	selectedClass ifNil: [ 
		UIManager default inform: 'No class selected.'.
		^ self ].

	instances := instanceCountInput text asInteger max: 1.

	swSystem := WSSoftwareSystem usingStrategy: (strategyDropList selectedItem withOriginClass: selectedClass).

	confirm := UIManager default confirm: 
		('Found ', swSystem classes size asString, ' classes for ', selectedClass name, '.', String cr, 'Do you want to run WFC?').
	confirm ifFalse: [ ^ self ].

	instances = 1
		ifTrue: [ self runInImage: swSystem ]
		ifFalse: [ self runInParallel: instances ].

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

{ #category : 'as yet unclassified' }
WSClassSelectionPresenter >> solverScriptPath [

	^ WSObject resourcesRootPath / 'script' / 'solver.st'
]

{ #category : 'as yet unclassified' }
WSClassSelectionPresenter >> solverSourceFor: aClass strategy: aStrategyClass [

	^ String streamContents: [ :s |
		s
			nextPutAll: '| swSystem adaptiveSolver |'; cr;
			nextPutAll: 'swSystem := WSSoftwareSystem'; cr;
			tab; nextPutAll: 'usingStrategy: ('.
		s
			nextPutAll: aStrategyClass name;
			nextPutAll: ' withOriginClass: ';
			nextPutAll: aClass name;
			nextPutAll: ').'; cr;
			nextPutAll: 'adaptiveSolver := WSAdaptive2DGridSolver'; cr;
			tab; nextPutAll: 'withTopology: WS2DRectangularGridTopology'; cr;
			tab; nextPutAll: 'andSwSystem: swSystem.'; cr;
			nextPutAll: 'adaptiveSolver run.' ]
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
