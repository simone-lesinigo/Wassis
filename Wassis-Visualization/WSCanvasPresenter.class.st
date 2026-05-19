"
Presenter with a canvas and a visualizer
"
Class {
	#name : 'WSCanvasPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
WSCanvasPresenter class >> withVisualizer: aVisualizer [
	
	^ self basicNew
        visualizer: aVisualizer;
        initialize;
        yourself
]

{ #category : 'initialization' }
WSCanvasPresenter >> initializePresenter [ 
	roassalPresenter := self newRoassal.
]

{ #category : 'accessing' }
WSCanvasPresenter >> roassalPresenter [

	^ roassalPresenter
]

{ #category : 'accessing' }
WSCanvasPresenter >> roassalPresenter: anObject [

	roassalPresenter := anObject
]

{ #category : 'initialization' }
WSCanvasPresenter >> setCanvas: aCanvas [
	
	roassalPresenter canvas: aCanvas
]
