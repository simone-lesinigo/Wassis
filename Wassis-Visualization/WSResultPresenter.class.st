"
Show the result of the exectuion
"
Class {
	#name : 'WSResultPresenter',
	#superclass : 'WSCanvasPresenter',
	#instVars : [
		'adaptiveSolver',
		'menuBar'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
WSResultPresenter class >> withAdaptiveSolver: anAdaptiveSolver [
	
	^ self new adaptiveSolver: anAdaptiveSolver
]

{ #category : 'accessing' }
WSResultPresenter >> adaptiveSolver [

	^ adaptiveSolver
]

{ #category : 'accessing' }
WSResultPresenter >> adaptiveSolver: anObject [

	adaptiveSolver := anObject
]

{ #category : 'initialization' }
WSResultPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
	 	  add: menuBar expand: false;
        add: roassalPresenter;
        yourself
]

{ #category : 'initialization-menuBar' }
WSResultPresenter >> initializeMenuBar [

    menuBar := self newMenuBar.
    menuBar addGroup: [ :group |
        group addItem: (self inspectItem).
        group addItem: (self saveItem).
        group addItem: (self visualizationItem) ]
]

{ #category : 'initialization' }
WSResultPresenter >> initializePresenter [ 
	super initializePresenter.
	self windowTitle: 'Wassis'.
	self initializeMenuBar.
	self applyLayout 
]

{ #category : 'initialization-menuBar' }
WSResultPresenter >> inspectItem [

    ^ [ :item | item name: 'Inspect'; iconName: #smallFind; action: [ adaptiveSolver inspect ] ]
]

{ #category : 'accessing' }
WSResultPresenter >> menuBar [

	^ menuBar
]

{ #category : 'accessing' }
WSResultPresenter >> menuBar: anObject [

	menuBar := anObject
]

{ #category : 'presenter opening' }
WSResultPresenter >> openAnimationPresenter [
	 "Open the presenter with the animation"
	
    | model colorMap animVisualizer animPresenter |
    colorMap := WSEntropyColorMap fromColor: Color red toColor: Color blue.
    model := WSAnimationModel fromSolver: adaptiveSolver solver.
    animVisualizer := WS2DRectangularGridAnimationVisualizer withModel: model andColorMap: colorMap.
    animPresenter := WSAnimationPresenter withModel: model.
	 animPresenter setCanvas: animVisualizer canvas; open
]

{ #category : 'presenter opening' }
WSResultPresenter >> openClassDistancesPresenter [
	"Open the presenter that visualize the class distances matrix"
	 | data classDistancePresenter |
	  data := WSClassDistancesVisualizer new visualizeClassDistancesMatrixFor: adaptiveSolver solver topology layoutStrategy.
    classDistancePresenter := WSClassDistancesPresenter new.
    classDistancePresenter
        initialClassDistances: data initialClassDistances;
        classDistances: data classDistances;
        composites: data composites;
        setCanvas: data initialCanvas;
        open
]

{ #category : 'presenter opening' }
WSResultPresenter >> openClassesGraphPresenter [
	
	| visualizer |
	visualizer:= WSClassesGraphVisualizer withClasses: (adaptiveSolver solver topology swSystem classes).
	visualizer createVisualization.
]

{ #category : 'presenter opening' }
WSResultPresenter >> openMDSPositionPresenter [
	
	| newVisualizer |
	newVisualizer := adaptiveSolver solver topology visualizer class new.
	newVisualizer visualizeMDSPositionFor: adaptiveSolver solver.
]

{ #category : 'presenter opening' }
WSResultPresenter >> openMetricsPresenter [
	
	WSMetricPresenter openWithMetrics: adaptiveSolver metrics
]

{ #category : 'initialization-menuBar' }
WSResultPresenter >> saveItem [

    ^ [ :item | item name: 'Save'; iconName: #smallSave; action: [ adaptiveSolver save ] ]
]

{ #category : 'initialization-menuBar' }
WSResultPresenter >> visualizationItem [

    ^ [ :item |
        item name: 'Visualization'; iconName: #haloView;
        subMenu: self visualizationSubMenu ]
]

{ #category : 'initialization-menuBar' }
WSResultPresenter >> visualizationSubMenu [

    ^ SpMenuPresenter new
        addItem: [ :sub | sub name: 'Animation'; action: [ self openAnimationPresenter ] ];
		  addItem: [ :sub | sub name: 'Metrics'; action: [ self openMetricsPresenter ] ];
        addItem: [ :sub | sub name: 'Classes Graph'; action: [ self openClassesGraphPresenter ] ];
        addItem: [ :sub | sub name: 'Class Distances'; action: [ self openClassDistancesPresenter ] ];
        addItem: [ :sub | sub name: 'MDS Positioning'; action: [ self openMDSPositionPresenter ] ];
        yourself
]
