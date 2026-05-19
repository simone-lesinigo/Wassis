"
Gropu the MDS layout strategies
"
Class {
	#name : 'WSMDSLayoutStrategy',
	#superclass : 'WSLayoutStrategy',
	#instVars : [
		'classes',
		'matrix',
		'dimension',
		'initialClassDistances',
		'classDistances'
	],
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'instance creation' }
WSMDSLayoutStrategy class >> computeForSystem: swSystem withDimension: aDimension [
	"Compute the matrix with the position calculated by MDS"
	
	| instance dict |
	
	(self cachedInstance isNil 
		or: [ swSystem hash ~= self swSystemHash 
			or: [ aDimension ~= self cachedDimension ]]) ifTrue: [  
			
				self swSystemHash: swSystem hash.
				self cachedDimension: aDimension.
				
				instance := self new.
				dict := Dictionary new.
				swSystem classes do: [ :eachClass | dict at: eachClass id put: eachClass ].
				
				self computationTime: [ instance classes: dict; dimension: aDimension; run ] timeToRun.
				self cachedInstance: instance 
	].

	^ self cachedInstance 
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> classDistances [

	^ classDistances
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> classDistances: anObject [

	classDistances := anObject
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> classes [

	^ classes
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> classes: anObject [

	classes := anObject
]

{ #category : 'calculating' }
WSMDSLayoutStrategy >> computeGraphDiameter [
    "Return the largest finite distance in the matrix"

    | n max |
    n := self classes size.
    max := 0.
    1 to: n do: [ :i |
        1 to: n do: [ :j |
            | v |
            v := self matrix at: i at: j.
            (v ~= Float infinity and: [ v > max ]) ifTrue: [ max := v ] ] ].
    ^ max
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> dimension [

	^ dimension
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> dimension: anObject [

	dimension := anObject
]

{ #category : 'initialization' }
WSMDSLayoutStrategy >> executeFloydWarshall [ 
	"Apply the floyd warshall algorithm to compute the distances (in terms of relations) between two classes"

	| v inf m |
	v := self classes size.
	inf := Float infinity.
	m := self matrix.
	
	1 to: v do: [ :k |
		1 to: v do: [ :i |
			1 to: v do: [ :j |
				(((m at: i at: k) ~= inf) and: [(m at: k at: j) ~= inf ]) 
					ifTrue: [ 
						| ij ikj |
						ij := m at: i at: j.
						ikj := (m at: i at: k) + (m at: k at: j).
						m at: i at: j put: (ij min: ikj) ]
				 ] ] ].
	

	
]

{ #category : 'creation' }
WSMDSLayoutStrategy >> fillDirectConnections [
	"Fill the distance matrix with direct connection weights"

	self classes do: [ :eachClass |
		eachClass connectedWith do: [ :eachConnection |
			 | sourceID targetID newWeight |
            sourceID := eachClass id.
            targetID := eachConnection target id.
				newWeight := eachConnection weight.
				self matrix at: sourceID at: targetID put: newWeight.
				self matrix at: targetID at: sourceID put: newWeight
		]
	].

	self initialClassDistances: self matrix deepCopy .
	
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> initialClassDistances [

	^ initialClassDistances
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> initialClassDistances: anObject [

	initialClassDistances := anObject
]

{ #category : 'initialization' }
WSMDSLayoutStrategy >> initializeDistanceMatrix [
	"Create the distances matrix filled with zeros on the diagonal, and inf in other"
    
    | n |
    n := self classes size.
    
    self matrix: (PMMatrix rows: n columns: n element: Float infinity).
	 self matrix setDiagonal: (Array new: n withAll: 0).
	
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> matrix [

	^ matrix
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> matrix: anObject [

	matrix := anObject
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> replaceInfiniteValues [
    "Replace remaining infinite distances with a value larger than the graph diameter"
    
    | n diameter |
    n := self classes size.
    diameter := self computeGraphDiameter.
    
    1 to: n do: [ :i |
        1 to: n do: [ :j |
            (self matrix at: i at: j) = Float infinity ifTrue: [
                self matrix at: i at: j put: diameter + 1 ] ] ]
]
