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
		'solver',
		'presenter'
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
WSVisualizer >> presenter [

	^ presenter
]

{ #category : 'accessing' }
WSVisualizer >> presenter: anObject [

	presenter := anObject
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
WSVisualizer >> visualizeMDSDistancesMatrixFor: aLayoutStrategy [
"Create the visualization of the matrix"

	| borderWidth size initialClassDistances classDistances nCol composites classNames |
	size := 200.
	borderWidth := 5.
	nCol := aLayoutStrategy initialClassDistances dimension y.
	initialClassDistances := aLayoutStrategy initialClassDistances flattenRows .
	classDistances := aLayoutStrategy classDistances flattenRows.
	
	    classNames := (aLayoutStrategy classes associations 
        asSortedCollection: [ :a :b | a key < b key ])
        collect: [ :assoc | assoc value name ].

	composites :=
		(initialClassDistances collect: [ :eachDistance | 
				| com shape label |
				shape := RSBox new 
					size: size;
					color: Color white; 
					borderColor: Color black; borderWidth: borderWidth;
					yourself.
				label := RSLabel new 
					text: (eachDistance = Float infinity ifTrue: [ 'Inf' ] ifFalse: [ eachDistance printString ]);
					fontSize: size * 0.3;
					color: Color black; yourself.
				com := RSComposite new add: shape; add: label; adjustToChildren; yourself.
		]).
	
	canvas addAll: composites.
	RSGridLayout new
		gapSize: 0 - borderWidth;
		lineItemsCount: nCol;
		on: canvas nodes.
		
	classNames doWithIndex: [ :name :i |
    | rowNode colNode rowLabel colLabel rowOffset colOffset rotateBy textLength |
    rowOffset := 30.
    colOffset := 15.
	 rotateBy := -45.

    rowNode := composites at: (i - 1) * nCol + 1.
    rowLabel := RSLabel new
        text: name;
        fontSize: size * 0.2;
        color: Color black;
        yourself.
    canvas add: rowLabel.
    rowLabel position: 
        (rowNode position x - (size / 2) - rowOffset - (rowLabel encompassingRectangle width / 2)) 
        @ rowNode position y.

    colNode := composites at: i.
    colLabel := RSLabel new
        text: name;
        fontSize: size * 0.2;
        color: Color black;
        yourself.
   	 canvas add: colLabel.
	textLength := colLabel encompassingRectangle width.
    colLabel rotateByDegrees: rotateBy .
    colLabel position: 
        colNode position x 
        @ (colNode position y - (size / 2) - colOffset - (colLabel encompassingRectangle height / 2)).
	 colLabel translateBy: 
		((textLength / 2) * ((90 - (rotateBy abs)) degreesToRadians sin)) @ 0.
].
		
	presenter := WSClassDistancesPresenter new.
	presenter 
		initialClassDistances: initialClassDistances;
		classDistances: classDistances;
		composites: composites;
		setCanvas: canvas;
		open.
]
