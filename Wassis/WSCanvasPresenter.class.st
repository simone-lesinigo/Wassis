"
Presenter with a canvas and a visualizer
"
Class {
	#name : 'WSCanvasPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'visualizer'
	],
	#category : 'Wassis-Presenter',
	#package : 'Wassis',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
WSCanvasPresenter class >> withVisualizer: aVisualizer [
	
	^ self basicNew
        visualizer: aVisualizer;
        initialize;
        yourself
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

{ #category : 'accessing' }
WSCanvasPresenter >> visualizer [

	^ visualizer
]

{ #category : 'accessing' }
WSCanvasPresenter >> visualizer: anObject [

	visualizer := anObject
]
