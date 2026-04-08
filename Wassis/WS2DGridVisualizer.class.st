"
Superclass of all the visualizers that uses a 2D matrix
"
Class {
	#name : 'WS2DGridVisualizer',
	#superclass : 'WSVisualizer',
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'visualization' }
WS2DGridVisualizer >> createVisualizationFor: aSolver [
	
	^ self subclassResponsibility
]
