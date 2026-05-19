"
Apply Multi Dimensional Scaling and the return the matrix with th position
"
Class {
	#name : 'WSClassicMDSLayoutStrategy',
	#superclass : 'WSMDSLayoutStrategy',
	#instVars : [
		'eigenvalues',
		'eigenvectors'
	],
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSClassicMDSLayoutStrategy >> applyDoubleCentering [
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
WSClassicMDSLayoutStrategy >> calculateEigenValuesAndVecotors [
	
	| aux |
	aux := self matrix eigen.
	
	self eigenvalues: aux values.
	self eigenvectors: aux vectors.
]

{ #category : 'calculating' }
WSClassicMDSLayoutStrategy >> computeEmbedding [

	self squareDistanceMatrix.  
	self applyDoubleCentering.  
	self calculateEigenValuesAndVecotors. 
	self createPositionMatrix 
]

{ #category : 'creation' }
WSClassicMDSLayoutStrategy >> createCenteringMatrix [
	"Create the centering matrix I - (1/n * Jn) where where n is the number of objects, I is the n x n identity matrix, and Jn is an n x n matrix of all ones"
	
	| identityMatrix jn n |
	n := self classes size.
	identityMatrix := PMMatrix identity: n.
	jn := (PMMatrix rows: n columns: n element: 1/n).
	
	^ identityMatrix - jn
]

{ #category : 'creation' }
WSClassicMDSLayoutStrategy >> createDiagonalEigenvaluesMatrix [
	"Create the diagonal matrix of egeinvalues. Note that it applies the square root"
	
	| dim dMatrix values |
	
	dim := self dimension.
	dMatrix := PMMatrix zerosRows: dim cols: dim.
	
	values := (self eigenvalues first: dim) collect: [ :each | each sqrt ].

	^ dMatrix setDiagonal: values.
	
	
	
	
	
	
]

{ #category : 'creation' }
WSClassicMDSLayoutStrategy >> createEm [
	"Create the matrix with the first m eigenvectors on columns"
	
	| em |
	em := PMMatrix rows: (self eigenvectors first: self dimension ).
	^ em transpose 
]

{ #category : 'creation' }
WSClassicMDSLayoutStrategy >> createPositionMatrix [
	"Compute X = Em * lambda^(1/2) where Em is the matrix of m largest eigenvectors and lambda is the diagonal matrix of m eigenvalues"

	| em lambda |
	
	em := self createEm.
	lambda := self createDiagonalEigenvaluesMatrix.
	self matrix: (em * lambda).
	
	
	
	
	
]

{ #category : 'accessing' }
WSClassicMDSLayoutStrategy >> eigenvalues [

	^ eigenvalues
]

{ #category : 'accessing' }
WSClassicMDSLayoutStrategy >> eigenvalues: anObject [

	eigenvalues := anObject
]

{ #category : 'accessing' }
WSClassicMDSLayoutStrategy >> eigenvectors [

	^ eigenvectors
]

{ #category : 'accessing' }
WSClassicMDSLayoutStrategy >> eigenvectors: anObject [

	eigenvectors := anObject
]

{ #category : 'calculating' }
WSClassicMDSLayoutStrategy >> normalizeMatrix [
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
WSClassicMDSLayoutStrategy >> normalizeMatrix2 [
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

{ #category : 'running' }
WSClassicMDSLayoutStrategy >> run [
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
WSClassicMDSLayoutStrategy >> squareDistanceMatrix [
	"Squares each value of the matrix"
	
	self matrix: (self matrix collect: [ :each | each squared ])
]

{ #category : 'visualization' }
WSClassicMDSLayoutStrategy >> visualizeEmbedding [
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
