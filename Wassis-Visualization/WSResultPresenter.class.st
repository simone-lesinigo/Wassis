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

{ #category : 'initialization' }
WSResultPresenter >> initializePresenter [ 
	super initializePresenter.
	self windowTitle: 'Wassis'.
	self initializeVisualizationMenuBar.
	self applyLayout 
]

{ #category : 'initialization' }
WSResultPresenter >> initializeVisualizationMenuBar [

    menuBar := self newMenuBar.
    menuBar addGroup: [ :group |
		  group addItem: [ :item |
            item name: 'Inspect'; action: [ adaptiveSolver inspect ] ] .
	
        group addItem: [ :item |
            item name: 'Visualization';
            subMenu: (SpMenuPresenter new
					 addItem: [ :sub | sub name: 'Animation'; action: [ self openAnimationPresenter ] ];
					 addItem: [ :sub | sub name: 'Classes Graph'; action: [ self openClassesGraphPresenter ] ];
                 addItem: [ :sub | sub name: 'Class Distances'; action: [ self openClassDistancesPresenter ] ];
                 addItem: [ :sub | sub name: 'MDS Positioning'; action: [ self openMDSPositionPresenter ] ];
                yourself) ] ]
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
