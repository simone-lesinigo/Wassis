"
Represents a 2D grid
"
Class {
	#name : 'WSGrid2D',
	#superclass : 'WSObject',
	#instVars : [
		'matrix',
		'nRows',
		'nColumns'
	],
	#category : 'Wassis-Structure',
	#package : 'Wassis',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
WSGrid2D class >> withRows: rows andColumns: columns [
	
	^ self new
		nRows: rows;
		nColumns: columns;
		matrix: ((1 to: rows) collect: [ :i | Array new: columns ]);
		yourself
]

{ #category : 'adding' }
WSGrid2D >> addNode: aNode [
    
    ^ self atRow: (aNode row) atColumn: (aNode column) put: aNode
]

{ #category : 'accessing' }
WSGrid2D >> atRow: aRow atColumn: aColumn [
	
	^ (self matrix at: aRow) at: aColumn
]

{ #category : 'accessing' }
WSGrid2D >> atRow: row atColumn: col put: anObject [

    ^ (self matrix at: row) at: col put: anObject
]

{ #category : 'collapse' }
WSGrid2D >> collectFootprintFrom: originNode size: sideLength [
    "Return all nodes in the NxN block with originNode as top-left"

    | result row col |
    result := OrderedCollection new.
    row := originNode row.
    col := originNode column.
    0 to: sideLength - 1 do: [ :dr |
        0 to: sideLength - 1 do: [ :dc |
            result add: (self atRow: (row + dr) atColumn: (col + dc)) ] ].
    ^ result
]

{ #category : 'enumerating' }
WSGrid2D >> firstColumnDo: aBlock [

    1 to: self nRows do: [ :i | 
        aBlock value: (self atRow: i atColumn: 1) ]
]

{ #category : 'enumerating' }
WSGrid2D >> firstRowDo: aBlock [

    1 to: self nColumns do: [ :j | 
        aBlock value: (self atRow: 1 atColumn: j) ]
]

{ #category : 'accessing' }
WSGrid2D >> getFlattenedNodes [ 
	
	^ self matrix flattened
]

{ #category : 'accessing' }
WSGrid2D >> getNeighboursOf: aNode atLevel: aNumber [
    "Return the Moore neighbours at exactly distance aNumber from aNode"
    
    | posX posY neighbours |
    posX := aNode row.
    posY := aNode column.
    neighbours := OrderedCollection new.
    
    (posX - aNumber) to: (posX + aNumber) do: [ :x |
        (posY - aNumber) to: (posY + aNumber) do: [ :y |
            ((x = (posX - aNumber) or: [ x = (posX + aNumber) ]) or: [
              y = (posY - aNumber) or: [ y = (posY + aNumber) ]])
                ifTrue: [
                    (self isInBoundsRow: x column: y) ifTrue: [
                        neighbours add: (self atRow: x atColumn: y) ] ] ] ].
    
    ^ neighbours
]

{ #category : 'testing' }
WSGrid2D >> isInBoundsRow: row column: col [

	^ (row between: 1 and: self nRows) and: [ col between: 1 and: self nColumns ]
]

{ #category : 'testing' }
WSGrid2D >> isValidTopLeft: aNode forSize: n withOffset: offset [
    "Note that this method is used only for placing classes when the graph is initialized.
	 A valid top-left node has:
     - the NxN footprint entirely within bounds and not collapsed
     - a 2 (default offset) cell border around the footprint entirely not collapsed"
    
   | minRow maxRow minCol maxCol |
	minRow := (aNode row) - offset.
	minCol := (aNode column) - offset.
	maxRow := (aNode row) + n + offset - 1.
	maxCol := (aNode column) + n + offset - 1.

	(self isInBoundsRow: minRow column: minCol ) ifFalse: [ ^ false ].
	(self isInBoundsRow: maxRow column: maxCol ) ifFalse: [ ^ false ].

	minRow to: maxRow do: [ :eachRow |
	    minCol to: maxCol do: [ :eachCol |
	        (self atRow: eachRow atColumn: eachCol) isCollapsed 
	            ifTrue: [ ^ false ] ] ].

	^ true
]

{ #category : 'enumerating' }
WSGrid2D >> lastColumnDo: aBlock [

    1 to: self nRows do: [ :i | 
        aBlock value: (self atRow: i atColumn: self nColumns) ]
]

{ #category : 'enumerating' }
WSGrid2D >> lastRowDo: aBlock [
    
	1 to: self nColumns do: [ :j | 
	        aBlock value: (self atRow: self nRows atColumn: j) ]
]

{ #category : 'accessing' }
WSGrid2D >> matrix [

	^ matrix
]

{ #category : 'accessing' }
WSGrid2D >> matrix: anObject [

	matrix := anObject
]

{ #category : 'accessing' }
WSGrid2D >> nColumns [

	^ nColumns
]

{ #category : 'accessing' }
WSGrid2D >> nColumns: anObject [

	nColumns := anObject
]

{ #category : 'accessing' }
WSGrid2D >> nRows [

	^ nRows
]

{ #category : 'accessing' }
WSGrid2D >> nRows: anObject [

	nRows := anObject
]

{ #category : 'collapse' }
WSGrid2D >> searchOutwardFrom: aNode forSize: n defaultOffset: offset [
    "Expand outward from aNode until a valid top-left position is found"
    
    | candidates level maxLevel |
    candidates := OrderedCollection new.
    level := 2.
    maxLevel := (self nRows max: self nColumns) // 2.
    
    [ candidates isEmpty and: [ level <= maxLevel ] ] whileTrue: [
	
		candidates := (self getNeighboursOf: aNode atLevel: level) select: [ :node | 
		    (node outgoingEdges size = 4) and: [ 
		        self isValidTopLeft: node forSize: n withOffset: offset 
		    ] 
		].

        level := level + 1 ].
    
    candidates ifEmpty: [ WSNoValidPlacementFound signal ].

    ^ candidates shuffled first
]
