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

{ #category : 'initialization' }
WSVisualizer >> clear [ 

	self canvas: RSCanvas new.
	self canvas @ RSCanvasController.
	self shapesNodes: Dictionary new.
	self nodesShapes: Dictionary new.
]

{ #category : 'visualization' }
WSVisualizer >> createVisualizationFor: aSolver [
	
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

{ #category : 'visualization-MDS' }
WSVisualizer >> visualizeMDSDistancesMatrixFor: aSolver [
"Create the visualization of the matrix"

	| composites borderWidth size mdsMatrix |
	self clear.
	mdsMatrix := aSolver topology layoutMatrix.
	size := 200.
	borderWidth := 5.
	
	composites := OrderedCollection new.
	mdsMatrix rows do: [ :eachRow | 
		eachRow do: [ :eachElement |
			| com shape label |
			shape := RSBox new 
				size: size;
				color: Color white; 
				borderColor: Color black; borderWidth: borderWidth;
				yourself.
			label := RSLabel new 
				text: (eachElement = Float infinity ifTrue: [ 'Inf' ] ifFalse: [ eachElement printString ]);
				fontSize: size * 0.3;
				color: Color black; yourself.
			com := RSComposite new add: shape; add: label; adjustToChildren; yourself.
			composites add: com.
		]
	].
	
	canvas addAll: composites.
	
	RSGridLayout new
		gapSize: 0 - borderWidth ;
		lineItemsCount: mdsMatrix dimension y;
		on: composites.
	
	canvas zoomToFit.
	canvas openOnceWithTitle: 'MDS Matrix'.
]
