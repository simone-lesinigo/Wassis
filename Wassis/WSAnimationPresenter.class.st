"
Presenter to visualize the animation of WFC
"
Class {
	#name : 'WSAnimationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'visualizer',
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
            add: stepBackButton ; add: playAndPauseButton; add: stepButton ; 
            yourself) expand: false;
        yourself
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeButtons [
	"Initialize the buttons of the presenter"
	
	stepButton := self newButton 
		label: 'Step';
		action: [ visualizer stepForward ];
		yourself.
	
	playAndPauseButton := self newButton 
		label: 'Play';
		action: [ visualizer play ];
		yourself.
	
    stepBackButton := self newButton
        label: 'Step Back';
        action: [ visualizer stepBack ];
        yourself.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializePresenter [
	
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

{ #category : 'accessing' }
WSAnimationPresenter >> visualizer [

	^ visualizer
]

{ #category : 'accessing' }
WSAnimationPresenter >> visualizer: anObject [

	visualizer := anObject
]
