"
Presenter to visualize the animation of WFC
"
Class {
	#name : 'WSAnimationPresenter',
	#superclass : 'WSCanvasPresenter',
	#instVars : [
		'resetButton',
		'stepBackButton',
		'playAndPauseButton',
		'stepButton',
		'statusLabel',
		'slider'
	],
	#category : 'Wassis-Presenter',
	#package : 'Wassis',
	#tag : 'Presenter'
}

{ #category : 'initialization' }
WSAnimationPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
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

{ #category : 'initialization' }
WSAnimationPresenter >> initializeButtons [
	"Initialize the buttons of the presenter"
	
	self initializeResetButton.
	self initializeStepBackButton.
	self initializeStepForwardButton.
	self initializeplayAndPauseButton 
	

	


]

{ #category : 'initialization' }
WSAnimationPresenter >> initializePresenter [

	self windowTitle: 'Wassis-Animation'.
	roassalPresenter := self newRoassal.
	
	self initializeStatusLabel.
	self initializeButtons.
	self initializeSlider.
	self applyLayout.
	self subscribeToEvents.


		
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeResetButton [
	
	resetButton := self newButton 
		label: 'Reset';
		action: [ self performReset ];
		yourself.
		
	resetButton enabled: false
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeSlider [
    slider := self newSlider.
    slider
        min: 0;
        max: visualizer maxIndex;      
		  whenValueChangedDo: [ :v |
            visualizer goToIndex: v rounded.
				self updateButtonStatus ]
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStatusLabel [

    statusLabel := self newLabel.
	 self updateLabelStatus 
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStepBackButton [
	
	stepBackButton := self newButton
      label: 'Step Back';
      action: [ self performStepBack ];
    	yourself.

	stepBackButton enabled: false.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStepForwardButton [
	
	stepButton := self newButton 
		label: 'Step Forward';
		action: [ self performStepForward ];
		yourself.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeplayAndPauseButton [
	
	playAndPauseButton := self newButton 
		label: 'Play';
		action: [ self togglePlayAndPauseButton ];
		yourself.
]

{ #category : 'event handling' }
WSAnimationPresenter >> onAnimationFinished [
	"Execute this method when the animation has finished"
	
	self updateStatus 
	playAndPauseButton label: 'Play'.
	

	
	
]

{ #category : 'event handling' }
WSAnimationPresenter >> performReset [
	
	visualizer goToStart.
	self updateButtonStatus.
]

{ #category : 'event handling' }
WSAnimationPresenter >> performStepBack [

    visualizer stepBack.
	 self updateButtonStatus.
    self updateLabelStatus.
]

{ #category : 'event handling' }
WSAnimationPresenter >> performStepForward [

    visualizer stepForward.
	 self updateButtonStatus.
    self updateLabelStatus.
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

	visualizer announcer 
		when: WSAnimationFinished 
		do: [ self onAnimationFinished ]
		for: self.
	
	visualizer announcer 
		when: WSAtStartOfAnimation 
		do: [ self atStartOfAnimation ]
		for: self.
	
	visualizer announcer 
		when: WSAnimationIndexChanged 
		do: [ self updateStatus  ]
		for: self
]

{ #category : 'control' }
WSAnimationPresenter >> togglePlayAndPauseButton [
	"Change the button between play and pause"
	
	visualizer isPlaying 
		ifTrue:  [
			self setEnableTo: true forButtons: { resetButton . stepBackButton . stepButton }.
			playAndPauseButton label: 'Play'.
			visualizer pause
		]
		ifFalse: [
			self setEnableTo: false forButtons: { resetButton . stepBackButton . stepButton }.
			playAndPauseButton label: 'Pause'.
			visualizer play.
		].
]

{ #category : 'update' }
WSAnimationPresenter >> updateButtonStatus [
    | atStart atEnd |
    atStart := visualizer index = 0.
    atEnd   := visualizer index = visualizer maxIndex.
    self setEnableTo: atStart not forButtons: { resetButton . stepBackButton }.
    self setEnableTo: atEnd not forButtons: { stepButton . playAndPauseButton }
]

{ #category : 'update' }
WSAnimationPresenter >> updateLabelStatus [
	"Update the status label with the percentage"

	 | percentage |
    percentage := (visualizer index / visualizer maxIndex * 100.0) printShowingDecimalPlaces: 1.
	 statusLabel label: 'Step: ' , visualizer index printString , ' / ' , visualizer maxIndex printString, ' (' , percentage , '%)'
]

{ #category : 'update' }
WSAnimationPresenter >> updateSliderIndexStatus [
	"Update the slider position"

	slider absoluteValue: (visualizer index / visualizer maxIndex).
]

{ #category : 'update' }
WSAnimationPresenter >> updateStatus [ 
	
	self updateButtonStatus.
	self updateLabelStatus.
	self updateSliderIndexStatus.
]
