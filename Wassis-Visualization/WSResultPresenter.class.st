"
Show the result of the exectuion
"
Class {
	#name : 'WSResultPresenter',
	#superclass : 'WSCanvasPresenter',
	#instVars : [
		'solver',
		'showAnimationButton'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'initialization' }
WSResultPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
        add: roassalPresenter;
		  add: showAnimationButton expand: false;
        yourself
]

{ #category : 'initialization' }
WSResultPresenter >> initializePresenter [ 
	super initializePresenter.
	self windowTitle: 'Wassis'.
	self initializeShowAnimationButton.
	self applyLayout 
]

{ #category : 'initialization' }
WSResultPresenter >> initializeShowAnimationButton [
	
	showAnimationButton:= self newButton 
		label: 'Show Animation';
		action: [ self openAnimationPresenter ];
		yourself.
]

{ #category : 'as yet unclassified' }
WSResultPresenter >> openAnimationPresenter [
	 "Open the presenter with the animation"
	
    | model colorMap animVisualizer animPresenter |
    colorMap := WSEntropyColorMap fromColor: Color red toColor: Color blue.
    model := WSAnimationModel fromSolver: self solver.
    animVisualizer := WS2DRectangularGridAnimationVisualizer withModel: model andColorMap: colorMap.
    animPresenter := WSAnimationPresenter withModel: model.
	 animPresenter setCanvas: animVisualizer canvas; open
]

{ #category : 'accessing' }
WSResultPresenter >> showAnimationButton [

	^ showAnimationButton
]

{ #category : 'accessing' }
WSResultPresenter >> showAnimationButton: anObject [

	showAnimationButton := anObject
]

{ #category : 'accessing' }
WSResultPresenter >> solver [

	^ solver
]

{ #category : 'accessing' }
WSResultPresenter >> solver: anObject [

	solver := anObject
]
