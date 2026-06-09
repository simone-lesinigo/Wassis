"
Metric MDS
"
Class {
	#name : 'WSMetricMDSLayoutStrategy',
	#superclass : 'WSMDSLayoutStrategy',
	#instVars : [
		'maxIterations',
		'power',
		'tolerance'
	],
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> applyPowerTransformation [ 
    "Transform distances: δij → δij^p (stored in classDistances)"

    | n |
    n := self classes size.
    1 to: n do: [ :i |
        1 to: n do: [ :j |
            | v |
            v := self classDistances at: i at: j.
            self classDistances at: i at: j put: (v raisedTo: power) ] ].
]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> buildInitialPositions [

    | n random |
    n := self classes size.
    random := Random new.
    ^ (1 to: n) collect: [ :i |
        { (random next * 2) - 1 . (random next * 2) - 1 } ]
]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> buildInitialPositions2 [
	"Initialize random positions in a 2D space based on the graph diameter"
	
	| n diameter random |
	n := self classes size.
	diameter := self computeGraphDiameter.
	random := Random new.
	
	^ (1 to: n) collect: [ :i |
		| x y |
		x := (random next * diameter) - (diameter / 2).
		y := (random next * diameter) - (diameter / 2).
		{ x . y }
	].
]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> buildMatrixFromPositions: positions [ 
	"Convert the final positions array back to a PMMatrix"
	
	| n pmMatrix |
	n := positions size.
	pmMatrix := PMMatrix zerosRows: n cols: self dimension.
	
	1 to: n do: [ :i |
		pmMatrix at: i at: 1 put: ((positions at: i) first).
		pmMatrix at: i at: 2 put: ((positions at: i) second).
	].
	
	self matrix: pmMatrix.
]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> calculateStressFor: positions [ 
	"Calculate the residual sum of squares (Stress)"
	
	| stress n |
	stress := 0.
	n := positions size.
	
	1 to: n - 1 do: [ :i |
		(i + 1) to: n do: [ :j |
			| targetDist currentDist diff |
			targetDist := self classDistances at: i at: j.
			currentDist := self euclideanDistanceBetween: (positions at: i) and: (positions at: j).
			diff := targetDist - currentDist.
			stress := stress + (diff * diff).
		]
	].
	^ stress
]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> computeBMatrixFor: positions [ 
	"Compute the B matrix for the SMACOF majorization step"
	
	| n |
	n := positions size.
	
	^ (1 to: n) collect: [ :i |
		| rowSum row |
		rowSum := 0.
		
		row := (1 to: n) collect: [ :j |
			i = j 
				ifTrue: [ 0 ]
				ifFalse: [ 
					| targetDist currentDist bValue |
					targetDist := self classDistances at: i at: j.
					currentDist := self euclideanDistanceBetween: (positions at: i) and: (positions at: j).
					
					bValue := currentDist > 1.0e-10
						ifTrue: [ (targetDist / currentDist) negated ]
						ifFalse: [ 0 ].
						
					rowSum := rowSum - bValue.
					bValue
				]
		].
		
		row at: i put: rowSum.
		row
	].
]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> euclideanDistanceBetween: pos1 and: pos2 [ 
	"Calculate standard 2D Euclidean distance"
	
	| dx dy |
	dx := (pos1 first) - (pos2 first).
	dy := (pos1 second) - (pos2 second).
	^ ((dx * dx) + (dy * dy)) sqrt
]

{ #category : 'initialization' }
WSMetricMDSLayoutStrategy >> initialize [ 

	 super initialize.
    maxIterations := 5000.
    tolerance := 1.0e-5.
    power := 1.  

]

{ #category : 'paper' }
WSMetricMDSLayoutStrategy >> makeShapeForClass: cls withSize: aSize [
 
    | box label composite |

    box := RSBox new size: aSize; color: Color black; yourself.
"	 box @ (RSPopup new text: cls name)."
    label := RSLabel new text: cls id printString; fontSize: aSize / 4; color: Color white; yourself.
    composite := RSComposite new.
    composite add: box; add: label; model: cls; adjustToChildren.
    composite @ (RSPopup new text: [ :model | model name ]).
	 composite draggable.

    ^ composite
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> maxIterations [

	^ maxIterations
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> maxIterations: anObject [

	maxIterations := anObject
]

{ #category : 'paper' }
WSMetricMDSLayoutStrategy >> openForceBasedCanvas [

	| canvas classShapes |
	canvas := RSCanvas new.
	classShapes := Dictionary new.
	canvas addAll: (self classes collect: [ :cls |
				 | shape |
				 shape := self makeShapeForClass: cls withSize: 20.
				 classShapes at: cls put: shape.
				 shape ]).

	self classes do: [ :eachClass |
		eachClass outgoingConnections do: [ :conn |
			canvas addAll: (conn relations collect: [ :rel |
				| color |
				color := rel name = #inheritance
					ifTrue: [ Color blue ]
					ifFalse: [ Color red ].
				RSLine new
					 from: (classShapes at: eachClass);
					 to: (classShapes at: conn target);
					 attachPoint: RSBorderAttachPoint new;
					 markerEnd: (RSMarker new shape: RSShapeFactory arrow; yourself);
					 color: color;
					 yourself ]) ] ].

	RSForceBasedLayout new
		charge: -500;
		on: canvas nodes.
		
	canvas @ RSCanvasController.
	canvas openWithTitle: 'Force-Based Layout'
]

{ #category : 'paper' }
WSMetricMDSLayoutStrategy >> openMDSPositionCanvas [

	| canvas classShapes |
	classShapes := Dictionary new.
	canvas := RSCanvas new.
   self classes doWithIndex: [ :cls :i |  
   		| shape pos |
      shape := self makeShapeForClass: cls withSize: 10.
      pos := self matrix atRow: i.
      shape position: (pos first @ pos second) * 500.
		classShapes at: cls put: shape.
      canvas add: shape ].
	
		self classes do: [ :eachClass |
		eachClass outgoingConnections do: [ :conn |
			canvas addAll: (conn relations collect: [ :rel |
				| color |
				color := rel name = #inheritance
					ifTrue: [ Color blue ]
					ifFalse: [ Color red ].
				RSLine new
					 from: (classShapes at: eachClass);
					 to: (classShapes at: conn target);
					 attachPoint: RSBorderAttachPoint new;
					 markerEnd: (RSMarker new shape: RSShapeFactory arrow; yourself);
					 color: color;
					 yourself ]) ] ].

	
	canvas @ RSCanvasController.
	canvas openWithTitle: 'Metric MDS'
]

{ #category : 'paper' }
WSMetricMDSLayoutStrategy >> openRectanglePackingCanvas [

    | canvas |
    canvas := RSCanvas new.

	canvas addAll: (self classes collect: [ :cls | 
		self makeShapeForClass: cls withSize: (cls allConnections size) * 10 ] ).

    RSRectanglePackLayout new applyOn: canvas nodes.

    canvas @ RSCanvasController.
    canvas openWithTitle: 'Rectangle Packing Layout'.
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> power [

	^ power
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> power: anObject [

	power := anObject
]

{ #category : 'running' }
WSMetricMDSLayoutStrategy >> run [ 

    | positions |
    self initializeDistanceMatrix.
    self fillDirectConnections.
    self executeFloydWarshall.
    self replaceInfiniteValues.
    self classDistances: self matrix deepCopy.

	self openRectanglePackingCanvas.
	 self openForceBasedCanvas.

    self applyPowerTransformation.

    positions := self buildInitialPositions.
    positions := self runSMACOF: positions.
    self buildMatrixFromPositions: positions.
	 self normalizeMatrix. 
	 self openMDSPositionCanvas. self halt.

]

{ #category : 'calculating' }
WSMetricMDSLayoutStrategy >> runSMACOF: initialPositions [ 
	"Iteratively update positions to minimize the stress function"
	
	| n currentPositions previousStress currentStress iteration |
	n := self classes size.
	currentPositions := initialPositions.
	previousStress := Float infinity.
	iteration := 0.
	
	[ iteration < self maxIterations ] whileTrue: [
		| bMatrix relativeChange |
		iteration := iteration + 1.

		currentStress := self calculateStressFor: currentPositions.
		
		relativeChange := (previousStress - currentStress) abs / (previousStress max: 1.0e-10).
      relativeChange < self tolerance ifTrue: [ ^ currentPositions ].
		previousStress := currentStress.
		
		bMatrix := self computeBMatrixFor: currentPositions.
		
		"X_new = (1/n) * B * X_old"
		currentPositions := (1 to: n) collect: [ :i |
			| newX newY |
			newX := 0.
			newY := 0.
			
			1 to: n do: [ :j |
				| bVal posJ |
				bVal := (bMatrix at: i) at: j.
				posJ := currentPositions at: j.
				
				newX := newX + (bVal * posJ first).
				newY := newY + (bVal * posJ second).
			].
			
			{ newX / n . newY / n }
		].
	].

	^ currentPositions
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> tolerance [

	^ tolerance
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> tolerance: anObject [

	tolerance := anObject
]
