"
Needed for presenter that have a model
"
Class {
	#name : 'WSModelPresenter',
	#superclass : 'WSCanvasPresenter',
	#instVars : [
		'model'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'instance creation' }
WSModelPresenter class >> withModel: aModel [

	^ self basicNew model: aModel; initialize
]

{ #category : 'accessing' }
WSModelPresenter >> model [

	^ model
]

{ #category : 'accessing' }
WSModelPresenter >> model: anObject [

	model := anObject
]
