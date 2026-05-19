"
Apply Multi Dimensional Scaling and the return the matrix with th position
"
Class {
	#name : 'WSMDSLayoutStrategy',
	#superclass : 'WSLayoutStrategy',
	#instVars : [
		'classes',
		'matrix',
		'eigenvalues',
		'eigenvectors',
		'dimension',
		'initialClassDistances',
		'classDistances'
	],
	#classInstVars : [
		'swSystemHash',
		'cachedInstance',
		'cachedDimension',
		'computationTime'
	],
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> cachedDimension [

	^ cachedDimension
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> cachedDimension: anObject [

	cachedDimension := anObject
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> cachedInstance [

	^ cachedInstance
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> cachedInstance: anObject [

	cachedInstance := anObject
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> computationTime [

	^ computationTime
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> computationTime: anObject [

	computationTime := anObject
]

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

{ #category : 'cleanup' }
WSMDSLayoutStrategy class >> resetCache [
	
	self swSystemHash: nil.
	self cachedInstance: nil.
	self cachedDimension: nil
	
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> swSystemHash [

	^ swSystemHash
]

{ #category : 'accessing' }
WSMDSLayoutStrategy class >> swSystemHash: anObject [

	swSystemHash := anObject
]

{ #category : 'calculating' }
WSMDSLayoutStrategy >> applyDoubleCentering [
	"Calculate double centering on the matrix. It means that both its row means and column means become zero"
	
    | n rowMeans grandMean |
    n := self matrix rows size.
    
    rowMeans := (1 to: n) collect: [ :i | 
        (self matrix rowAt: i) average ].
    
    grandMean := rowMeans average.

    1 to: n do: [ :i |
        1 to: n do: [ :j |
            | val |
            val := self matrix at: i at: j.
            val := (val - (rowMeans at: i) - (rowMeans at: j) + grandMean).
            self matrix at: i at: j put: (val * -0.5)
        ]
    ].
"	""Calculate double centering on the matrix. It means that both its row means and column means become zero""
	| centeringMatrix intermediate |
	centeringMatrix := self createCenteringMatrix.
	Transcript show:'Finished centering matrix'.
	intermediate := centeringMatrix * self matrix * centeringMatrix.
	Transcript show:'Finished intermediate'.
	
	self matrix: ((0 - (1/2)) * intermediate)"
	
]

{ #category : 'calculating' }
WSMDSLayoutStrategy >> calculateEigenValuesAndVecotors [
	
	| aux |
	aux := self matrix eigen.
	
	self eigenvalues: aux values.
	self eigenvectors: aux vectors.
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
WSMDSLayoutStrategy >> computeEmbedding [

	self squareDistanceMatrix.  
	self applyDoubleCentering.  
	self calculateEigenValuesAndVecotors. 
	self createPositionMatrix 
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

{ #category : 'creation' }
WSMDSLayoutStrategy >> createCenteringMatrix [
	"Create the centering matrix I - (1/n * Jn) where where n is the number of objects, I is the n x n identity matrix, and Jn is an n x n matrix of all ones"
	
	| identityMatrix jn n |
	n := self classes size.
	identityMatrix := PMMatrix identity: n.
	jn := (PMMatrix rows: n columns: n element: 1/n).
	
	^ identityMatrix - jn
]

{ #category : 'creation' }
WSMDSLayoutStrategy >> createDiagonalEigenvaluesMatrix [
	"Create the diagonal matrix of egeinvalues. Note that it applies the square root"
	
	| dim dMatrix values |
	
	dim := self dimension.
	dMatrix := PMMatrix zerosRows: dim cols: dim.
	
	values := (self eigenvalues first: dim) collect: [ :each | each sqrt ].

	^ dMatrix setDiagonal: values.
	
	
	
	
	
	
]

{ #category : 'creation' }
WSMDSLayoutStrategy >> createEm [
	"Create the matrix with the first m eigenvectors on columns"
	
	| em |
	em := PMMatrix rows: (self eigenvectors first: self dimension ).
	^ em transpose 
]

{ #category : 'creation' }
WSMDSLayoutStrategy >> createPositionMatrix [
	"Compute X = Em * lambda^(1/2) where Em is the matrix of m largest eigenvectors and lambda is the diagonal matrix of m eigenvalues"

	| em lambda |
	
	em := self createEm.
	lambda := self createDiagonalEigenvaluesMatrix.
	self matrix: (em * lambda).
	
	
	
	
	
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> dimension [

	^ dimension
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> dimension: anObject [

	dimension := anObject
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> eigenvalues [

	^ eigenvalues
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> eigenvalues: anObject [

	eigenvalues := anObject
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> eigenvectors [

	^ eigenvectors
]

{ #category : 'accessing' }
WSMDSLayoutStrategy >> eigenvectors: anObject [

	eigenvectors := anObject
]

{ #category : 'calculating' }
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

{ #category : 'calculating' }
WSMDSLayoutStrategy >> normalizeMatrix [
    "Normalize all dimensions using a single global min/max"

    | dim nRows nColumns globalMin globalMax den |
    dim := self matrix dimension.
    nRows := dim x.
    nColumns := dim y.

    globalMin := Float infinity.
    globalMax := Float infinity negated.

    1 to: nColumns do: [ :col |
        | values |
        values := self matrix columnAt: col.
        globalMin := globalMin min: values min.
        globalMax := globalMax max: values max ].

    den := globalMax - globalMin.

    1 to: nColumns do: [ :col |
        | values normalized |
        values := self matrix columnAt: col.
        normalized := den = 0
            ifTrue: [ Array new: nRows withAll: 0.5 ]
            ifFalse: [ values collect: [ :each | (each - globalMin) / den ] ].
        self matrix atColumn: col put: normalized ]
]

{ #category : 'calculating' }
WSMDSLayoutStrategy >> normalizeMatrix2 [
	"Normalize the values of each column between 0 and 1"

	| dim nRows nColumns |
	dim := self matrix dimension.
	nRows := dim x.
	nColumns := dim y.

	1 to: nColumns do: [ :col |
		| values min den normalized |
		values := self matrix columnAt: col.
		min := values min.
		den := values max - min.
		
		 normalized := den = 0
            ifTrue: [ Array new: nRows withAll: 0.5 ]
            ifFalse: [ values collect: [ :each | (each - min) / den ] ].

		self matrix atColumn: col put: normalized.
	]
]

{ #category : 'calculating' }
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

{ #category : 'running' }
WSMDSLayoutStrategy >> run [
    "Run MDS: build distance matrix, apply Floyd-Warshall, compute embedding"
    
	self initializeDistanceMatrix.
	self fillDirectConnections.
   self executeFloydWarshall.
	self replaceInfiniteValues. 
	self classDistances: self matrix.
   self computeEmbedding. 
   self normalizeMatrix.
	self visualizeEmbedding.
]

{ #category : 'calculating' }
WSMDSLayoutStrategy >> squareDistanceMatrix [
	"Squares each value of the matrix"
	
	self matrix: (self matrix collect: [ :each | each squared ])
]

{ #category : 'visualization' }
WSMDSLayoutStrategy >> visualizeEmbedding [
    "Visualize the MDS embedding"
    
    | canvas shapes |
    canvas := RSCanvas new.
    
    shapes := self classes keysAndValuesDo: [ :id :class |
        | row shape scaleBy |
		  scaleBy := 100.
        row := self matrix rowAt: id.

        shape := RSComposite new.
		  shape add: (RSEllipse new size: 10)";
			 add: (RSLabel new text: class name)".
		 	shape adjustToChildren.

        canvas add: shape.
        shape translateTo: (row first * scaleBy ) @ (row second * scaleBy ).
			 shape @ (RSPopup new text: ('name: {4} {3} Pos: {1} @ {2} ' format: {row first . row second . String cr . class name}))
].
		 
    
    canvas @ RSCanvasController.
    ^ canvas open
]
