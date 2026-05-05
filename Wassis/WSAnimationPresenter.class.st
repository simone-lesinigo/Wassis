Class {
	#name : 'WSAnimationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'inspectButton',
		'stepButton',
		'playButton',
		'pauseButton',
		'isPlaying',
		'semaphore',
		'adaptiveSolver'
	],
	#category : 'Wassis-Presenter',
	#package : 'Wassis',
	#tag : 'Presenter'
}

{ #category : 'initialization - deprecated' }
WSAnimationPresenter >> initializePresenter [
	
	stepButton := self newButton 
		label: 'Step';
		action: [ semaphore signal ];
		yourself.
	
	playButton := self newButton
		label: 'Play';
      action: [ 
            isPlaying value: true.
            semaphore signal ];
      yourself.

    pauseButton := self newButton
       label: 'Pause';
       action: [ isPlaying value: false ];
       yourself.
		
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
WSAnimationPresenter >> pauseButton [

	^ pauseButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> pauseButton: anObject [

	pauseButton := anObject
]

{ #category : 'accessing' }
WSAnimationPresenter >> playButton [

	^ playButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> playButton: anObject [

	playButton := anObject
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
WSAnimationPresenter >> stepButton [

	^ stepButton
]

{ #category : 'accessing' }
WSAnimationPresenter >> stepButton: anObject [

	stepButton := anObject
]
