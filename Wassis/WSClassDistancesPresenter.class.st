"
Presenter to visualize the matrix of class distances
"
Class {
	#name : 'WSClassDistancesPresenter',
	#superclass : 'WSCanvasPresenter',
	#instVars : [
		'toggleButton',
		'initialClassDistances',
		'classDistances',
		'composites',
		'showingInitial'
	],
	#category : 'Wassis-Presenter',
	#package : 'Wassis',
	#tag : 'Presenter'
}

{ #category : 'initialization' }
WSClassDistancesPresenter >> applyLayout [ 
	"Apply the layout on the presenter"	

	layout := SpBoxLayout newVertical
        add: roassalPresenter;
        add: (SpBoxLayout newHorizontal
            add: toggleButton ;
            yourself) expand: false;
        yourself
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> classDistances [

	^ classDistances
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> classDistances: anObject [

	classDistances := anObject
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> composites [

	^ composites
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> composites: anObject [

	composites := anObject
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> initialClassDistances [

	^ initialClassDistances
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> initialClassDistances: anObject [

	initialClassDistances := anObject
]

{ #category : 'initialization' }
WSClassDistancesPresenter >> initializePresenter [

	self windowTitle: 'Class Distances'.
	roassalPresenter := self newRoassal.
	showingInitial := true.
	
	self initializeToggleButton.
	self applyLayout 
]

{ #category : 'initialization' }
WSClassDistancesPresenter >> initializeToggleButton [
	
	toggleButton := self newButton 
		label: 'Calculate distances';
		action: [
			showingInitial 
				ifTrue: [ 
					toggleButton label: 'Return to start'.
					self switchToMatrix: classDistances.		
				] 
				ifFalse: [ 
					toggleButton label: 'Calculate distances'.
					self switchToMatrix: initialClassDistances 
				].
			showingInitial := showingInitial not.	
		];
		yourself.
	
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> showingInitial [

	^ showingInitial
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> showingInitial: anObject [

	showingInitial := anObject
]

{ #category : 'initialization' }
WSClassDistancesPresenter >> switchToMatrix: anArray [
	"Change the labels in the distances matrix"

    composites doWithIndex: [ :com :i |
        | element label |
        element := anArray at: i.
        label := com shapes detect: [ :eachShape | eachShape class = RSLabel ].
        label text: (element = Float infinity ifTrue: [ 'Inf' ] ifFalse: [ element printString ]).
    ].
    roassalPresenter canvas signalUpdate.
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> toggleButton [

	^ toggleButton
]

{ #category : 'accessing' }
WSClassDistancesPresenter >> toggleButton: anObject [

	toggleButton := anObject
]
