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

{ #category : 'visualization' }
WS2DGridVisualizer >> updateVisualizationFor: aNodesArray [
	"For each node in nodes array it updates the visualization (without recreating the whole visualization)"
	
	^ self subclassResponsibility 
]
