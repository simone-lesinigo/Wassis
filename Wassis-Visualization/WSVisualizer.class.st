"
Create the visualization for a certain type of graph
"
Class {
	#name : 'WSVisualizer',
	#superclass : 'WSObject',
	#instVars : [
		'canvas',
		'tileVisitor',
		'shapesNodes',
		'nodesShapes',
		'solver'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
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

{ #category : 'initialization' }
WSVisualizer >> clear [ 

	self canvas: RSCanvas new.
	self canvas @ RSCanvasController.
	self shapesNodes: Dictionary new.
	self nodesShapes: Dictionary new.
]

{ #category : 'visualization' }
WSVisualizer >> createCanvasFor: aSolver [
	
	^ self subclassResponsibility 
]

{ #category : 'initialization' }
WSVisualizer >> initialize [

	super initialize.
	self clear
]

{ #category : 'accessing' }
WSVisualizer >> nodesShapes [

	^ nodesShapes
]

{ #category : 'accessing' }
WSVisualizer >> nodesShapes: anObject [

	nodesShapes := anObject
]

{ #category : 'accessing' }
WSVisualizer >> shapesNodes [

	^ shapesNodes
]

{ #category : 'accessing' }
WSVisualizer >> shapesNodes: anObject [

	shapesNodes := anObject
]

{ #category : 'accessing' }
WSVisualizer >> solver [

	^ solver
]

{ #category : 'accessing' }
WSVisualizer >> solver: anObject [

	solver := anObject
]

{ #category : 'accessing' }
WSVisualizer >> tileVisitor [

	^ tileVisitor
]

{ #category : 'accessing' }
WSVisualizer >> tileVisitor: anObject [

	tileVisitor := anObject
]
