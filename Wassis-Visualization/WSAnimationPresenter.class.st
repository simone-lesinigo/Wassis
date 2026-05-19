"
Presenter to visualize the animation of WFC
"
Class {
	#name : 'WSAnimationPresenter',
	#superclass : 'WSModelPresenter',
	#instVars : [
		'resetButton',
		'stepBackButton',
		'playAndPauseButton',
		'stepButton',
		'classDistancesButton',
		'mdsPositionButton',
		'heapButton',
		'statusLabel',
		'slider'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'initialization' }
WSAnimationPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
        add: (SpBoxLayout newHorizontal
        		add: classDistancesButton ; add: mdsPositionButton ; add: heapButton; 
            yourself) expand: false;
        add: roassalPresenter;
		  add: statusLabel expand: false;
		  add: slider expand: false;
        add: (SpBoxLayout newHorizontal
            add: resetButton; add: stepBackButton; add: playAndPauseButton; add: stepButton ; 
            yourself) expand: false;
        yourself
]

{ #category : 'event handling' }
WSAnimationPresenter >> atStartOfAnimation [
	"Execute this method when the animation has not started yet"
	
	self updateStatus.
]

{ #category : 'accessing' }
WSAnimationPresenter >> classDistancesButton [

	^ classDistancesButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> classDistancesButton: anObject [

	classDistancesButton := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> heapButton [

	^ heapButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> heapButton: anObject [

	heapButton := anObject
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeButtons [
	"Initialize the buttons of the presenter"
	
	self initializeClassDistancesButton. 
	self initializeMDSPositionButton.
	self initializeHeapButton.
	self initializeResetButton.
	self initializeStepBackButton.
	self initializeStepForwardButton.
	self initializeplayAndPauseButton.

	

	


]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeClassDistancesButton [
	
	classDistancesButton := self newButton 
		label: 'Open Class Distances Visualization';
		action: [ self openClassDistancesPresenter ];
		yourself.
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeHeapButton [
	
	heapButton := self newButton 
		label: 'Open Heap Visualization';
		action: [ self openHeapPresenter ];
		yourself.
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeMDSPositionButton [
	
	mdsPositionButton := self newButton 
		label: 'Open MDS Position Visualization';
		action: [ self openMDSPositionPresenter ];
		yourself.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializePresenter [

	super initializePresenter.
	self windowTitle: 'Wassis-Animation'.
	
	self initializeStatusLabel.
	self initializeButtons.
	self initializeSlider.
	self applyLayout.
	self subscribeToEvents.


		
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeResetButton [
	
	resetButton := self newButton 
		label: 'Reset';
		action: [ model goToStart ];
		yourself.
		
	resetButton enabled: false
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeSlider [

    slider := self newSlider.
    slider
        min: 0;
        max: model maxIndex;      
		  whenValueChangedDo: [ :v |
            model goToIndex: v rounded ]
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStatusLabel [

    statusLabel := self newLabel.
	 self updateLabelStatus 
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeStepBackButton [
	
	stepBackButton := self newButton
      label: 'Step Back';
      action: [ model stepBack ];
    	yourself.

	stepBackButton enabled: false.
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeStepForwardButton [
	
	stepButton := self newButton 
		label: 'Step Forward';
		action: [ model stepForward ];
		yourself.
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> initializeplayAndPauseButton [
	
	playAndPauseButton := self newButton 
		label: 'Play';
		action: [ self togglePlayAndPauseButton ];
		yourself.
]

{ #category : 'accessing' }
WSAnimationPresenter >> mdsPositionButton [

	^ mdsPositionButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> mdsPositionButton: anObject [

	mdsPositionButton := anObject
]

{ #category : 'event handling' }
WSAnimationPresenter >> onAnimationFinished [
	"Execute this method when the animation has finished"
	
	self updateStatus 
	playAndPauseButton label: 'Play'.
	

	
	
]

{ #category : 'presenter opening' }
WSAnimationPresenter >> openClassDistancesPresenter [
	"Open the presenter that visualize the class distances matrix"
	 | data classDistancePresenter |
	  data := WSVisualizer new visualizeClassDistancesMatrixFor: model solver topology layoutStrategy.
    classDistancePresenter := WSClassDistancesPresenter new.
    classDistancePresenter
        initialClassDistances: data initialClassDistances;
        classDistances: data classDistances;
        composites: data composites;
        setCanvas: data initialCanvas;
        open
]

{ #category : 'initialization-buttons' }
WSAnimationPresenter >> openMDSPositionPresenter [
	
	| newVisualizer |
	newVisualizer := model solver topology visualizer class new.
	newVisualizer visualizeMDSPositionFor: model solver.
]

{ #category : 'accessing' }
WSAnimationPresenter >> playAndPauseButton [

	^ playAndPauseButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> playAndPauseButton: anObject [

	playAndPauseButton := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> resetButton [

	^ resetButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> resetButton: anObject [

	resetButton := anObject
]

{ #category : 'control' }
WSAnimationPresenter >> setEnableTo: aBoolean forButtons: colOfButtons [
	
	colOfButtons do: [ :eachButton | eachButton enabled: aBoolean ]
]

{ #category : 'accessing' }
WSAnimationPresenter >> slider [

	^ slider
]

{ #category : 'accessing' }
WSAnimationPresenter >> slider: anObject [

	slider := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> statusLabel [

	^ statusLabel
]

{ #category : 'accessing' }
WSAnimationPresenter >> statusLabel: anObject [

	statusLabel := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepBackButton [

	^ stepBackButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepBackButton: anObject [

	stepBackButton := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepButton [

	^ stepButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepButton: anObject [

	stepButton := anObject
]

{ #category : 'initialization' }
WSAnimationPresenter >> subscribeToEvents [

	model announcer 
		when: WSAnimationFinished 
		do: [ self onAnimationFinished ]
		for: self.
	
	model announcer 
		when: WSAtStartOfAnimation 
		do: [ self atStartOfAnimation ]
		for: self.
	
	model announcer 
		when: WSAnimationIndexChanged 
		do: [ self updateStatus ]
		for: self
]

{ #category : 'control' }
WSAnimationPresenter >> togglePlayAndPauseButton [
	"Change the button between play and pause"
	
	model isPlaying 
		ifTrue:  [
			self setEnableTo: true forButtons: { resetButton . stepBackButton . stepButton }.
			playAndPauseButton label: 'Play'.
			model pause
		]
		ifFalse: [
			self setEnableTo: false forButtons: { resetButton . stepBackButton . stepButton }.
			playAndPauseButton label: 'Pause'.
			model play.
		].
]

{ #category : 'update' }
WSAnimationPresenter >> updateButtonStatus [
    | atStart atEnd |
    atStart := model index = 0.
    atEnd   := model index = model maxIndex.
    self setEnableTo: atStart not forButtons: { resetButton . stepBackButton }.
    self setEnableTo: atEnd not forButtons: { stepButton . playAndPauseButton }
]

{ #category : 'update' }
WSAnimationPresenter >> updateLabelStatus [
	"Update the status label with the percentage"

	 | percentage |
    percentage := (model index / model  maxIndex * 100.0) printShowingDecimalPlaces: 1.
	 statusLabel label: 'Step: ' , model  index printString , ' / ' , model  maxIndex printString, ' (' , percentage , '%)'
]

{ #category : 'update' }
WSAnimationPresenter >> updateSliderIndexStatus [
	"Update the slider position"

	slider absoluteValue: (model  index / model  maxIndex).
]

{ #category : 'update' }
WSAnimationPresenter >> updateStatus [ 
	
	self updateLabelStatus.
	self updateSliderIndexStatus.
	model  isPlaying ifTrue: [ ^ self ].
	self updateButtonStatus.
]
