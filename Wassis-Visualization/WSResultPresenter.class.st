"
Show the result of the exectuion
"
Class {
	#name : 'WSResultPresenter',
	#superclass : 'WSCanvasPresenter',
	#instVars : [
		'solver',
		'visualizationMenuBar'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'initialization' }
WSResultPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
	 	  add: visualizationMenuBar expand: false;
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

    visualizationMenuBar := self newMenuBar.
    visualizationMenuBar addGroup: [ :group |
        group addItem: [ :item |
            item name: 'Visualization';
            subMenu: (SpMenuPresenter new
					 addItem: [ :sub | sub name: 'Animation'; action: [ self openAnimationPresenter ] ];
					 addItem: [ :sub | sub name: 'Classes Graph'; action: [ self openClassesGraphPresenter ] ];
                 addItem: [ :sub | sub name: 'Class Distances'; action: [ self openClassDistancesPresenter ] ];
                 addItem: [ :sub | sub name: 'MDS Positioning'; action: [ self openMDSPositionPresenter ] ];
                yourself) ] ]
]

{ #category : 'presenter opening' }
WSResultPresenter >> openAnimationPresenter [
	 "Open the presenter with the animation"
	
    | model colorMap animVisualizer animPresenter |
    colorMap := WSEntropyColorMap fromColor: Color red toColor: Color blue.
    model := WSAnimationModel fromSolver: self solver.
    animVisualizer := WS2DRectangularGridAnimationVisualizer withModel: model andColorMap: colorMap.
    animPresenter := WSAnimationPresenter withModel: model.
	 animPresenter setCanvas: animVisualizer canvas; open
]

{ #category : 'presenter opening' }
WSResultPresenter >> openClassDistancesPresenter [
	"Open the presenter that visualize the class distances matrix"
	 | data classDistancePresenter |
	  data := WSClassDistancesVisualizer new visualizeClassDistancesMatrixFor: solver topology layoutStrategy.
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
	visualizer:= WSClassesGraphVisualizer withClasses: (solver topology swSystem classes).
	visualizer createVisualization.
]

{ #category : 'presenter opening' }
WSResultPresenter >> openMDSPositionPresenter [
	
	| newVisualizer |
	newVisualizer := solver topology visualizer class new.
	newVisualizer visualizeMDSPositionFor: solver.
]

{ #category : 'accessing' }
WSResultPresenter >> solver [

	^ solver
]

{ #category : 'accessing' }
WSResultPresenter >> solver: anObject [

	solver := anObject
]
