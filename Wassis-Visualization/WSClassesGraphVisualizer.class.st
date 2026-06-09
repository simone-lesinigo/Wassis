"
""Create the visualization of a graph (with node and edges) where the nodes are the classes and the edges are the connection between them""
"
Class {
	#name : 'WSClassesGraphVisualizer',
	#superclass : 'WSObject',
	#instVars : [
		'canvas',
		'classesArray',
		'nodeShapes'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'instance creation' }
WSClassesGraphVisualizer class >> withClasses: aClassesArray [
	
	^ self new classesArray: aClassesArray 
]

{ #category : 'accessing' }
WSClassesGraphVisualizer >> canvas [

	^ canvas
]

{ #category : 'accessing' }
WSClassesGraphVisualizer >> canvas: anObject [

	canvas := anObject
]

{ #category : 'accessing' }
WSClassesGraphVisualizer >> classesArray [

	^ classesArray
]

{ #category : 'accessing' }
WSClassesGraphVisualizer >> classesArray: anObject [

	classesArray := anObject
]

{ #category : 'visualization' }
WSClassesGraphVisualizer >> createLines [
	"Create the lines between two classes"

    | targets |
    
    self classesArray do: [ :eachClass |
		targets := eachClass outgoingConnections 
			collect: [ :eachConnection | eachConnection target ].
		
        targets isNotEmpty ifTrue: [
            RSEdgeBuilder line
                canvas: self canvas;
                withBorderAttachPoint;
					 arrowMarkerEnd;
                connectFrom: eachClass
                toAll: targets.
        ]
    ]
]

{ #category : 'visualization' }
WSClassesGraphVisualizer >> createShapes [
	"Creates all the nodes of the graph"
	
	self nodesShapes: (self classesArray collect: [ :eachClass |
		| shape |
		shape := RSBox new size: 50; color: Color black .
		shape @ (RSPopup new text: eachClass name asString).
		shape model: eachClass; draggable.
	]).

	self canvas addAll: self nodesShapes
]

{ #category : 'visualization' }
WSClassesGraphVisualizer >> createVisualization [
	"Create the visualization of the graph of the classes"
	
	self createShapes.
	self createLines.
	
	RSForceBasedLayout new
		charge: -5000;
		on: self canvas nodes.

	self canvas @ RSCanvasController.
	self canvas openOnceWithTitle: 'Classes Graph'
]

{ #category : 'initialization' }
WSClassesGraphVisualizer >> initialize [ 

	super initialize.
	self canvas: RSCanvas new.
	self canvas @ RSCanvasController.
]

{ #category : 'accessing' }
WSClassesGraphVisualizer >> nodesShapes [

	^ nodeShapes
]

{ #category : 'accessing' }
WSClassesGraphVisualizer >> nodesShapes: anObject [

	nodeShapes := anObject
]
