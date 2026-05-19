"
Visualize the distances between classes
"
Class {
	#name : 'WSClassDistancesVisualizer',
	#superclass : 'WSObject',
	#instVars : [
		'canvas'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'visualization' }
WSClassDistancesVisualizer >> addAxisLabels: classNames composites: composites columnCount: nCol [
	"Add the labels on the rows and the columns"

    classNames doWithIndex: [ :name :i |
        self addRowLabel: name index: i composites: composites columnCount: nCol.
        self addColLabel: name index: i composites: composites ]
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> addColLabel: name index: i composites: composites [
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

{ #category : 'visualization' }
WSClassDistancesVisualizer >> addRowLabel: name index: i composites: composites columnCount: nCol [
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

{ #category : 'visualization' }
WSClassDistancesVisualizer >> buildDistanceBox [
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

{ #category : 'visualization' }
WSClassDistancesVisualizer >> buildDistanceCompositeFor: aDistance [
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

{ #category : 'visualization' }
WSClassDistancesVisualizer >> buildDistanceComposites: distanceValues [
	"Build the composites to visualize the MDS values"
	
    ^ distanceValues collect: [ :eachDistance |
        self buildDistanceCompositeFor: eachDistance ]
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> buildDistanceLabelFor: aDistance [
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
WSClassDistancesVisualizer >> canvas [

	^ canvas
]

{ #category : 'accessing' }
WSClassDistancesVisualizer >> canvas: anObject [

	canvas := anObject
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> distanceCellBorderWidth [

    ^ 5
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> distanceCellSize [

    ^ 200
]

{ #category : 'initialization' }
WSClassDistancesVisualizer >> initialize [ 

	super initialize.
	self canvas: RSCanvas new.
	self canvas @ RSCanvasController.
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> layoutComposites: composites columnCount: nCol [
	"Apply the grid layout on the canvas"
	
    canvas addAll: composites.
    RSGridLayout new
        gapSize: 0 - self distanceCellBorderWidth;
        lineItemsCount: nCol;
        on: canvas nodes
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> sortedClassNamesFrom: aLayoutStrategy [
	"Sort the class names of the swSystem based on their ID"
	
    ^ (aLayoutStrategy classes associations
        asSortedCollection: [ :a :b | a key < b key ])
        collect: [ :assoc | assoc value name ]
]

{ #category : 'visualization' }
WSClassDistancesVisualizer >> visualizeClassDistancesMatrixFor: aLayoutStrategy [
    "Create the visualization of the matrix of distances given to MDS"

    | nCol initialClassDistances classDistances classNames composites |
    nCol := aLayoutStrategy initialClassDistances dimension y.
    initialClassDistances := aLayoutStrategy initialClassDistances flattenRows.
    classDistances := aLayoutStrategy classDistances flattenRows.
    classNames := self sortedClassNamesFrom: aLayoutStrategy.

    composites := self buildDistanceComposites: initialClassDistances.
    self layoutComposites: composites columnCount: nCol.
    self addAxisLabels: classNames composites: composites columnCount: nCol.
	 
	 ^ WSClassDistancesPresenterData new
			initialClassDistances: initialClassDistances;
			classDistances: classDistances;
			composites: composites;
			initialCanvas: self canvas;
			yourself
]
