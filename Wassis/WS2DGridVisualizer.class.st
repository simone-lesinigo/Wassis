"
Superclass of all the visualizers that uses a 2D matrix
"
Class {
	#name : 'WS2DGridVisualizer',
	#superclass : 'WSVisualizer',
	#instVars : [
		'classComposites'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'accessing' }
WS2DGridVisualizer >> classComposites [

	^ classComposites
]

{ #category : 'accessing' }
WS2DGridVisualizer >> classComposites: anObject [

	classComposites := anObject
]

{ #category : 'visualization' }
WS2DGridVisualizer >> createVisualizationFor: aSolver [
	
	^ self subclassResponsibility
]

{ #category : 'initialization' }
WS2DGridVisualizer >> initialize [ 
	
	super initialize.
	self classComposites: Dictionary new
]
