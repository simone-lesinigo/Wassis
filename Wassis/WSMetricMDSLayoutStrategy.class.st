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

{ #category : 'as yet unclassified' }
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

{ #category : 'initialization' }
WSMetricMDSLayoutStrategy >> initialize [ 

	 super initialize.
    maxIterations := 300.
    tolerance := 1.0e-6.
    power := 1.  

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
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> tolerance [

	^ tolerance
]

{ #category : 'accessing' }
WSMetricMDSLayoutStrategy >> tolerance: anObject [

	tolerance := anObject
]
