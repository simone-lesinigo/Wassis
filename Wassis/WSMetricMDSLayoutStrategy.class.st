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
	
	| n bMatrix |
	n := positions size.
	bMatrix := Array new: n.
	1 to: n do: [ :i | bMatrix at: i put: (Array new: n withAll: 0) ].
	
	1 to: n do: [ :i |
		| rowSum |
		rowSum := 0.
		1 to: n do: [ :j |
			i ~= j ifTrue: [
				| targetDist currentDist bValue |
				targetDist := self classDistances at: i at: j.
				currentDist := self euclideanDistanceBetween: (positions at: i) and: (positions at: j).
				
				bValue := currentDist > 1.0e-6
					ifTrue: [ (targetDist / currentDist) negated ]
					ifFalse: [ 0 ].
					
				(bMatrix at: i) at: j put: bValue.
				rowSum := rowSum - bValue.
			]
		].

		(bMatrix at: i) at: i put: rowSum.
	].
	^ bMatrix
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
    maxIterations := 500.
    tolerance := 1.0e-6.
    power := 0.8.  

]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> maxIterations [

	^ maxIterations
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> maxIterations: anObject [

	maxIterations := anObject
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
    self applyPowerTransformation.

    positions := self buildInitialPositions.
    positions := self runSMACOF: positions.
    self buildMatrixFromPositions: positions.
	 self normalizeMatrix.
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
		| bMatrix newPositions |
		iteration := iteration + 1.
		
		currentStress := self calculateStressFor: currentPositions.
		
		(previousStress - currentStress) abs < self tolerance ifTrue: [
			^ currentPositions
		].
		previousStress := currentStress.
		
		bMatrix := self computeBMatrixFor: currentPositions.
		
		"X_new = (1/n) * B * X_old"
		newPositions := Array new: n.
		1 to: n do: [ :i |
			| newX newY |
			newX := 0.
			newY := 0.
			1 to: n do: [ :j |
				| bVal posJ |
				bVal := (bMatrix at: i) at: j.
				posJ := currentPositions at: j.
				newX := newX + (bVal * (posJ at: 1)).
				newY := newY + (bVal * (posJ at: 2)).
			].
			newPositions at: i put: { newX / n . newY / n }.
		].
		
		currentPositions := newPositions.
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
