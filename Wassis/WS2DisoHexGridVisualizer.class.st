"
Create the viusalization using an hexagonal isometric grid
"
Class {
	#name : 'WS2DisoHexGridVisualizer',
	#superclass : 'WS2DGridVisualizer',
	#instVars : [
		'shapesPosition'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'adding' }
WS2DisoHexGridVisualizer >> addHexNodeAt: aPoint baseCenter: baseCenter radius: radius solver: aSolver [

   | i j node prism newX newY |
	i := aPoint x.
	j := aPoint y.
	
   node := (self matrix nodes at: i) at: j.
   prism := self createShapeFor: node inPosition: baseCenter withRadius: radius.
   self canvas add: prism.
   self shapesPosition at: i @ j put: prism.
    
    newX := baseCenter x + (3/2 * radius).
    newY := baseCenter y + (j odd 
        ifTrue:  [ 3 sqrt / 2 * radius ] 
        ifFalse: [ 3 sqrt / 2 * radius negated ]).
    ^ newX @ newY
]

{ #category : 'visualization' }
WS2DisoHexGridVisualizer >> applyOrder: aSolver [
	"Push the right shapes to the front"
	
	aSolver topology nColumns to: 1 by: -1 do: [ :j | 
		1 to: aSolver topology nRows do: [ :i | 
			self canvas pushFront: (self shapesPosition at: (i @ j ))
		]
	].
]

{ #category : 'visualization' }
WS2DisoHexGridVisualizer >> createHexGrid: aSolver [
    | radius baseCenter |
    radius := 20.
    1 to: aSolver topology nRows do: [ :i |
        baseCenter := 0 @ ((i - 1) * (3 sqrt * radius)).
        1 to: aSolver topology nColumns do: [ :j |
            baseCenter := self addHexNodeAt: i @ j 
                                baseCenter: baseCenter 
                                radius: radius
                                solver: aSolver ] ].
]

{ #category : 'creation' }
WS2DisoHexGridVisualizer >> createShapeFor: aNode inPosition: aPoint withRadius: aRadius [
	
		| center height color tile |
		
		tile := aNode tileInWhichCollapsed.
		center := { aPoint x . aPoint y . 0 }.
		
		tile isEmptyTile 
			ifTrue: [ height := 10. color:= Color white ].
		
		tile isPathTile 
			ifTrue: [ 
				height := 20. 
				color:= self tileVisitor pathIDColorDictionary at: (aNode tileInWhichCollapsed pathID) ].
			
		tile isClassTile 
			ifTrue: [ height := 50. color:= Color orange ].
		
		^ self tileVisitor 
			createHexPrismWithBaseCenter: center 
			andRadius: aRadius 
			andHeight: height 
			andColor: color
	
]

{ #category : 'visualization' }
WS2DisoHexGridVisualizer >> createVisualizationFor: aSolver [
	"Create the visualization at the end of the execution"
	
	self initializeFor: aSolver.
	self createHexGrid: aSolver.
	self applyOrder: aSolver.
   self canvas openOnce.
]

{ #category : 'initialization' }
WS2DisoHexGridVisualizer >> initialize [ 
	super initialize.
	self shapesPosition: Dictionary new.
]

{ #category : 'initialization' }
WS2DisoHexGridVisualizer >> initializeFor: aSolver [

	self matrix: aSolver graph.
	self shapesNodes: Dictionary new.
	self tileVisitor: 
		(WS2DHexVisitor withPathIDs: 
			(aSolver topology swSystem classesPathIDs)).
]

{ #category : 'accessing' }
WS2DisoHexGridVisualizer >> shapesPosition [

	^ shapesPosition
]

{ #category : 'accessing' }
WS2DisoHexGridVisualizer >> shapesPosition: anObject [

	shapesPosition := anObject
]
