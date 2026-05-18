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

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> addAxisLabels: classNames composites: composites columnCount: nCol [
	"Add the labels on the rows and the columns"

    classNames doWithIndex: [ :name :i |
        self addRowLabel: name index: i composites: composites columnCount: nCol.
        self addColLabel: name index: i composites: composites ]
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> addColLabel: name index: i composites: composites [
	"Create the labels of class names for the columns. Rotate them for better visualization"

    | colNode label offset rotateBy textLength textHeight |
    offset := 15.
    rotateBy := -45.
    colNode := composites at: i.
    label := RSLabel new
        text: name;
        fontSize: self distanceCellSize * 0.2;
        color: Color black;
        yourself.
    canvas add: label.
    textLength := label encompassingRectangle width.
    textHeight := label encompassingRectangle height.
    label rotateByDegrees: rotateBy.
    label position:
        colNode position x
        @ (colNode position y - (self distanceCellSize / 2) - offset - (label encompassingRectangle height / 2)).
    label translateBy:
        ((textLength / 2) * ((90 - rotateBy abs) degreesToRadians sin)) - ((textHeight / 2) * (rotateBy abs degreesToRadians sin)) @ 0
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> addRowLabel: name index: i composites: composites columnCount: nCol [
	"Add the of class names labels for the rows. Align them at the end"

    | rowNode label offset |
    offset := 30.
    rowNode := composites at: (i - 1) * nCol + 1.
    label := RSLabel new
        text: name;
        fontSize: self distanceCellSize * 0.2;
        color: Color black;
        yourself.
    canvas add: label.
    label position:
        (rowNode position x - (self distanceCellSize / 2) - offset - (label encompassingRectangle width / 2)) @ rowNode position y
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> buildDistanceBox [
	"Build the box to visualize the distance"
	
    | size borderWidth |
    size := self distanceCellSize.
    borderWidth := self distanceCellBorderWidth.
    ^ RSBox new
        size: size;
        color: Color white;
        borderColor: Color black;
        borderWidth: borderWidth;
        yourself
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> buildDistanceCompositeFor: aDistance [
	"Create the composite for a single disatnce between two classes"

    | shape label |
    shape := self buildDistanceBox.
    label := self buildDistanceLabelFor: aDistance.
    ^ RSComposite new
        add: shape;
        add: label;
        adjustToChildren;
        yourself
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> buildDistanceComposites: distanceValues [
	"Build the composites to visualize the MDS values"
	
    ^ distanceValues collect: [ :eachDistance |
        self buildDistanceCompositeFor: eachDistance ]
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> buildDistanceLabelFor: aDistance [
	"Create the labels to put in each composite, represting the distance"

    | text |
    text := aDistance = Float infinity ifTrue: [ 'Inf' ] ifFalse: [ aDistance printString ].
    ^ RSLabel new
        text: text;
        fontSize: self distanceCellSize * 0.3;
        color: Color black;
        yourself
]

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

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> distanceCellBorderWidth [

    ^ 5
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> distanceCellSize [

    ^ 200
]

{ #category : 'initialization' }
WSVisualizer >> initialize [

	super initialize.
	self clear
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> layoutComposites: composites columnCount: nCol [
	"Apply the grid layout on the canvas"
	
    canvas addAll: composites.
    RSGridLayout new
        gapSize: 0 - self distanceCellBorderWidth;
        lineItemsCount: nCol;
        on: canvas nodes
]

{ #category : 'accessing' }
WSVisualizer >> nodesShapes [

	^ nodesShapes
]

{ #category : 'accessing' }
WSVisualizer >> nodesShapes: anObject [

	nodesShapes := anObject
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> openPresenterWith: initialClassDistances classDistances: classDistances composites: composites [

    presenter := WSClassDistancesPresenter new.
    presenter
        initialClassDistances: initialClassDistances;
        classDistances: classDistances;
        composites: composites;
        setCanvas: canvas;
        open
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

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> sortedClassNamesFrom: aLayoutStrategy [
	"Sort the class names of the swSystem based on their ID"
	
    ^ (aLayoutStrategy classes associations
        asSortedCollection: [ :a :b | a key < b key ])
        collect: [ :assoc | assoc value name ]
]

{ #category : 'accessing' }
WSVisualizer >> tileVisitor [

	^ tileVisitor
]

{ #category : 'accessing' }
WSVisualizer >> tileVisitor: anObject [

	tileVisitor := anObject
]

{ #category : 'visualization-ClassDistances' }
WSVisualizer >> visualizeClassDistancesMatrixFor: aLayoutStrategy [
    "Create the visualization of the matrix of distances given to MDS"

    | nCol initialClassDistances classDistances classNames composites |
    nCol := aLayoutStrategy initialClassDistances dimension y.
    initialClassDistances := aLayoutStrategy initialClassDistances flattenRows.
    classDistances := aLayoutStrategy classDistances flattenRows.
    classNames := self sortedClassNamesFrom: aLayoutStrategy.

    composites := self buildDistanceComposites: initialClassDistances.
    self layoutComposites: composites columnCount: nCol.
    self addAxisLabels: classNames composites: composites columnCount: nCol.

    self openPresenterWith: initialClassDistances classDistances: classDistances composites: composites.
]
