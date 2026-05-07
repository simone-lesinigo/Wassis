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
		'stepButton'
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
        add: (SpBoxLayout newHorizontal
            add: resetButton; add: stepBackButton; add: playAndPauseButton; add: stepButton ; 
            yourself) expand: false;
        yourself
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeButtons [
	"Initialize the buttons of the presenter"
	
	resetButton := self newButton 
		label: 'Reset';
		action: [ visualizer goToStart ];
		yourself.
	
	stepBackButton := self newButton
      label: 'Step Back';
      action: [ visualizer stepBack ];
      yourself.
	
	stepButton := self newButton 
		label: 'Step';
		action: [ visualizer stepForward ];
		yourself.
	
	playAndPauseButton := self newButton 
		label: 'Play';
		action: [ self togglePlayAndPauseButton ];
		yourself.

]

{ #category : 'initialization' }
WSAnimationPresenter >> initializePresenter [
	
	self windowTitle: 'Wassis-Animation'.
	roassalPresenter := self newRoassal.
	
	self initializeButtons.
	self applyLayout
		
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

{ #category : 'as yet unclassified' }
WSAnimationPresenter >> togglePlayAndPauseButton [
	"Change the button between play and pause"
	
	resetButton enabled: resetButton isEnabled not.
	stepButton enabled: stepButton isEnabled not.
	stepBackButton enabled: stepBackButton isEnabled not.
	
	visualizer isPlaying 
		ifTrue:  [
			playAndPauseButton label: 'Play'.
			visualizer pause
		]
		ifFalse: [  
			playAndPauseButton label: 'Pause'.
			visualizer play.
		].
]

{ #category : 'accessing' }
WSAnimationPresenter >> visualizer [

	^ visualizer
]

{ #category : 'accessing' }
WSAnimationPresenter >> visualizer: anObject [

	visualizer := anObject
]
