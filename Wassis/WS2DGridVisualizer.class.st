"
Superclass of all the visualizers that uses a 2D matrix
"
Class {
	#name : 'WS2DGridVisualizer',
	#superclass : 'WSVisualizer',
	#instVars : [
		'matrix',
		'shapesNodes'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'visualization' }
WS2DGridVisualizer >> createVisualizationFor: aSolver [
	
	^ self subclassResponsibility
]

{ #category : 'accessing' }
WS2DGridVisualizer >> matrix [

	^ matrix
]

{ #category : 'accessing' }
WS2DGridVisualizer >> matrix: anObject [

	matrix := anObject
]

{ #category : 'accessing' }
WS2DGridVisualizer >> shapesNodes [

	^ shapesNodes
]

{ #category : 'accessing' }
WS2DGridVisualizer >> shapesNodes: anObject [

	shapesNodes := anObject
]
