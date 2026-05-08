"
Presenter to visualize the animation of WFC
"
Class {
	#name : 'WSAnimationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'visualizer',
		'resetButton',
		'stepBackButton',
		'playAndPauseButton',
		'stepButton',
		'statusLabel'
	],
	#category : 'Wassis-Presenter',
	#package : 'Wassis',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
WSAnimationPresenter class >> withVisualizer: aVisualizer [
	
	^ self basicNew
        visualizer: aVisualizer;
        initialize;
        yourself
]

{ #category : 'initialization' }
WSAnimationPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
        add: roassalPresenter;
		  add: statusLabel expand: false;
		  spacing: 2;
        add: (SpBoxLayout newHorizontal
            add: resetButton; add: stepBackButton; add: playAndPauseButton; add: stepButton ; 
            yourself) expand: false;
        yourself
]

{ #category : 'event handling' }
WSAnimationPresenter >> atStartOfAnimation [
	"Execute this method when the animation has not started yet"
		
	self setEnableTo: false forButtons: { resetButton . stepBackButton }
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeButtons [
	"Initialize the buttons of the presenter"
	
	self initializeResetButton.
	self initializeStepBackButton.
	self initializeStepButton.
	self initializeplayAndPauseButton 
	

	


]

{ #category : 'initialization' }
WSAnimationPresenter >> initializePresenter [

	self windowTitle: 'Wassis-Animation'.
	roassalPresenter := self newRoassal.
	
	self initializeStatusLabel.
	self initializeButtons.
	self applyLayout.
	self subscribeToEvents.


		
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeResetButton [
	
	resetButton := self newButton 
		label: 'Reset';
		action: [ 
			visualizer goToStart.
			self setEnableTo: true forButtons: { playAndPauseButton . stepButton }.
			self setEnableTo: false forButtons: { resetButton . stepBackButton }.				
		];
		yourself.
	
	resetButton enabled: false.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStatusLabel [

    statusLabel := self newLabel.
	 self updateStatusLabel 
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStepBackButton [
	
	stepBackButton := self newButton
      label: 'Step Back';
      action: [ 
			self setEnableTo: true forButtons: { playAndPauseButton . stepButton }. 
			visualizer stepBack. 	
		];
    	yourself.

	stepBackButton enabled: false.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeStepButton [
	
	stepButton := self newButton 
		label: 'Step Forward';
		action: [ 
			self setEnableTo: true forButtons: {  resetButton . stepBackButton }. 
			visualizer stepForward ];
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
	
	self setEnableTo: true forButtons: { resetButton . stepBackButton }.
	stepButton enabled: false.
	
	playAndPauseButton 
		enabled: false;
		label: 'Play'.
	

	
	
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

{ #category : 'accessing' }
WSAnimationPresenter >> roassalPresenter [

	^ roassalPresenter
]

{ #category : 'accessing' }
WSAnimationPresenter >> roassalPresenter: anObject [

	roassalPresenter := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> setCanvas: aCanvas [
	
	roassalPresenter canvas: aCanvas
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
		do: [ self updateStatusLabel ]
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
WSAnimationPresenter >> updateStatusLabel [

	 | percentage |
    percentage := (visualizer index / visualizer maxIndex * 100.0) printShowingDecimalPlaces: 1.
	 statusLabel label: 'Step: ' , visualizer index printString , ' / ' , visualizer maxIndex printString, ' (' , percentage , '%)'
]

{ #category : 'accessing' }
WSAnimationPresenter >> visualizer [

	^ visualizer
]

{ #category : 'accessing' }
WSAnimationPresenter >> visualizer: anObject [

	visualizer := anObject
]
