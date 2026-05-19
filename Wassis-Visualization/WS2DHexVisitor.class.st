"
Visualize an hexagon tile
"
Class {
	#name : 'WS2DHexVisitor',
	#superclass : 'WSTileVisitor',
	#instVars : [
		'position',
		'shapesPosition',
		'hexagonColor'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : '2DHexagon' }
WS2DHexVisitor >> createFacePointsWithRadius: aRadius [
	"Create the 6 vertices of a polygon with the given raidius"
	
	^ (0 to: 5) collect: [ :i |
   		| angle point |
      angle := (i * 60) degreesToRadians.
      point := aRadius * angle cos @ (aRadius * angle sin) ].
]

{ #category : '2DIsometricHexagonPrism' }
WS2DHexVisitor >> createHexPrismWithBaseCenter: aPoint andRadius: aRadius andHeight: aHeight andColor: aColor [
	"Create a prism with hexagonal base. aPoint is the center of the base, not the center of the prism. Note that aPoint is actually an Array of 3 elements (x, y, z)"

	| height facePoints topFace bottomFace group |
	group := RSGroup new.
	height := aHeight.

	facePoints := self createFacePointsWithRadius: aRadius.

	bottomFace := facePoints collect: [ :eachPoint |
		self isometricViewOf3DPoint: (eachPoint + (aPoint first @ aPoint second)) withHeight: aPoint third ].

	topFace := facePoints collect: [ :eachPoint |
		self isometricViewOf3DPoint: (eachPoint + (aPoint first @ aPoint second)) withHeight: (aPoint third + height) ].

"	group add: (RSPolygon new
			 points: bottomFace;
			 color: Color blue;
			 border: (RSBorder new color: Color black; width: 1))."
			
	group addAll: (#( 2 3 4  ) collect: [ :i |
				 | next p1 p2 p3 p4 |
				 next := i % 6 + 1.
				 p1 := bottomFace at: i.
				 p2 := bottomFace at: next.
				 p3 := topFace at: next.
				 p4 := topFace at: i.
				 RSPolygon new
					 points: { p1. p2. p3. p4 };
					 color: aColor ;
					 border: (RSBorder new color: Color black; width: 1) ]).

	group add: (RSPolygon new
			 points: topFace;
			 color: aColor ;
			 border: (RSBorder new color: Color black; width: 1)).

	^ group asShape
]

{ #category : 'accessing' }
WS2DHexVisitor >> hexagonColor [

	^ hexagonColor
]

{ #category : 'accessing' }
WS2DHexVisitor >> hexagonColor: anObject [

	hexagonColor := anObject
]

{ #category : 'initialization' }
WS2DHexVisitor >> initialize [ 
	super initialize.
	self shapesPosition: Dictionary new.
]

{ #category : 'accessing' }
WS2DHexVisitor >> position [

	^ position
]

{ #category : 'accessing' }
WS2DHexVisitor >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
WS2DHexVisitor >> shapesPosition [

	^ shapesPosition
]

{ #category : 'accessing' }
WS2DHexVisitor >> shapesPosition: anObject [

	shapesPosition := anObject
]
