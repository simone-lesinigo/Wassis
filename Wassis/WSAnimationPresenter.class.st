Class {
	#name : 'WSAnimationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'inspectButton',
		'stepButton',
		'isPlaying',
		'semaphore',
		'adaptiveSolver',
		'playAndPauseButton'
	],
	#category : 'Wassis-Presenter',
	#package : 'Wassis',
	#tag : 'Presenter'
}

{ #category : 'accessing' }
WSAnimationPresenter >> adaptiveSolver [

	^ adaptiveSolver
]

{ #category : 'accessing' }
WSAnimationPresenter >> adaptiveSolver: anObject [

	adaptiveSolver := anObject
]

{ #category : 'initialization' }
WSAnimationPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	
		
	layout := SpBoxLayout newVertical
        add: roassalPresenter;
        add: (SpBoxLayout newHorizontal
            add: stepButton; add: playAndPauseButton;
            yourself) expand: false;
        yourself
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializeButtons [
	"Initialize the buttons of the presenter"
	
	stepButton := self newButton 
		label: 'Step';
		action: [ semaphore signal ];
		yourself.
	
	playAndPauseButton := self newButton 
		label: 'Play';
		action: [ self togglePlayAndPauseButton ];
		yourself.
]

{ #category : 'initialization' }
WSAnimationPresenter >> initializePresenter [
	
	isPlaying := false.
	roassalPresenter := self newRoassal.
	
	self initializeButtons.
	self applyLayout
		
]

{ #category : 'accessing' }
WSAnimationPresenter >> inspectButton [

	^ inspectButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> inspectButton: anObject [

	inspectButton := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> isPlaying [

	^ isPlaying
]

{ #category : 'accessing' }
WSAnimationPresenter >> isPlaying: anObject [

	isPlaying := anObject
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
WSAnimationPresenter >> semaphore [

	^ semaphore
]

{ #category : 'accessing' }
WSAnimationPresenter >> semaphore: anObject [

	semaphore := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> setCanvas: aCanvas [
	
	roassalPresenter canvas: aCanvas
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepButton [

	^ stepButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepButton: anObject [

	stepButton := anObject
]

{ #category : 'changing state' }
WSAnimationPresenter >> togglePlayAndPauseButton [
	"Change the play with the pause button and viceversa"
	
	isPlaying 
		ifTrue: [ 
			isPlaying := false. 
			playAndPauseButton label: 'Play' ]
		ifFalse: [ 
			isPlaying := true. 
			semaphore signal. 
			playAndPauseButton label: 'Pause' ]
]
