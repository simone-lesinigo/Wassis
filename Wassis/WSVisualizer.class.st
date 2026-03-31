"
Create the visualization for a certain type of graph
"
Class {
	#name : 'WSVisualizer',
	#superclass : 'WSObject',
	#instVars : [
		'canvas',
		'tileVisualizer'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'accessing' }
WSVisualizer >> canvas [

	^ canvas
]

{ #category : 'accessing' }
WSVisualizer >> canvas: anObject [

	canvas := anObject
]

{ #category : 'visualization' }
WSVisualizer >> createVisualizationFor: aSolver [
	
	^ self subclassResponsibility 
]

{ #category : 'initialization' }
WSVisualizer >> initialize [

	super initialize.
	self canvas: RSCanvas new.
	self canvas @ RSCanvasController.
]

{ #category : 'accessing' }
WSVisualizer >> tileVisualizer [

	^ tileVisualizer
]

{ #category : 'accessing' }
WSVisualizer >> tileVisualizer: anObject [

	tileVisualizer := anObject
]
