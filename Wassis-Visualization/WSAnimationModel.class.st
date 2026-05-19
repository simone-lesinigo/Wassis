"
Model for the animation
"
Class {
	#name : 'WSAnimationModel',
	#superclass : 'WSObject',
	#instVars : [
		'solver',
		'announcer',
		'index',
		'maxIndex',
		'isPlaying',
		'msDelay'
	],
	#category : 'Wassis-Visualization-Model',
	#package : 'Wassis-Visualization',
	#tag : 'Model'
}

{ #category : 'instance creation' }
WSAnimationModel class >> fromSolver: aSolver [
	
	^ self basicNew solver: aSolver; initialize
]

{ #category : 'accessing' }
WSAnimationModel >> announcer [

	^ announcer
]

{ #category : 'accessing' }
WSAnimationModel >> announcer: anObject [

	announcer := anObject
]

{ #category : 'animation' }
WSAnimationModel >> goToIndex: aTargetIndex [
    "Go to the specified index of the visualization"

    (aTargetIndex < 0 or: [ aTargetIndex > maxIndex ]) ifTrue: [ self error: 'Index out of bounds' ].

    index < aTargetIndex
        ifTrue:  [ index to: aTargetIndex - 1 do: [ :_ | self stepForward ] ]
        ifFalse: [ index to: aTargetIndex + 1 by: -1 do: [ :_ | self stepBack ] ]
]

{ #category : 'animation' }
WSAnimationModel >> goToStart [
	"Reset the canvas to the initial state"
	
	index to: 0 by: -1 do: [ :i |
		self stepBack 
	]
]

{ #category : 'accessing' }
WSAnimationModel >> index [

	^ index
]

{ #category : 'accessing' }
WSAnimationModel >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
WSAnimationModel >> initialize [
	
	super initialize.
	index := 0.
	maxIndex := solver executionHistory historyOfCollapsedNodes size.
	isPlaying := false.
	msDelay := 50.
	announcer := Announcer new.
]

{ #category : 'accessing' }
WSAnimationModel >> isPlaying [

	^ isPlaying
]

{ #category : 'accessing' }
WSAnimationModel >> isPlaying: anObject [

	isPlaying := anObject
]

{ #category : 'accessing' }
WSAnimationModel >> maxIndex [

	^ maxIndex
]

{ #category : 'accessing' }
WSAnimationModel >> maxIndex: anObject [

	maxIndex := anObject
]

{ #category : 'accessing' }
WSAnimationModel >> msDelay [

	^ msDelay
]

{ #category : 'accessing' }
WSAnimationModel >> msDelay: anObject [

	msDelay := anObject
]

{ #category : 'animation' }
WSAnimationModel >> pause [
	"Pause the animation"
	
	self isPlaying: false
]

{ #category : 'animation' }
WSAnimationModel >> play [
	"Play the animation forward"
	
	[ isPlaying := true.	
	   [( index <  maxIndex) and:  isPlaying] whileTrue: [
	   		self stepForward.
	      (Delay forMilliseconds:  msDelay) wait. 
	   ].
		 index =  maxIndex ifTrue: [ 
			 isPlaying := false.
			 announcer announce: WSAnimationFinished .
		]
	] forkNamed: 'WassisPlayAnimation'
]

{ #category : 'accessing' }
WSAnimationModel >> solver [

	^ solver
]

{ #category : 'accessing' }
WSAnimationModel >> solver: anObject [

	solver := anObject
]

{ #category : 'animation' }
WSAnimationModel >> stepBack [
	"Return to the previous step of the visualization on the canvas"

	index - 1 = 0 ifTrue: [ self announcer announce: WSAtStartOfAnimation. ].
	index > 0 ifFalse: [ ^ self ].
	index := index - 1.
	announcer announce: WSAnimationIndexChanged; announce: WSAnimationStepBack 
]

{ #category : 'animation' }
WSAnimationModel >> stepForward [
	"Draw the next step of the visualization on the canvas"

	index + 1 =  maxIndex ifTrue: [  announcer announce: WSAnimationFinished  ].
	index <  maxIndex ifFalse: [ ^ self ].
	index := index + 1.
	announcer announce: WSAnimationIndexChanged; announce: WSAnimationStepForward 
]
