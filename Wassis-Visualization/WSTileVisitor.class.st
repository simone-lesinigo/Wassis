"
Given a tile, it knows how to visualize it
"
Class {
	#name : 'WSTileVisitor',
	#superclass : 'WSObject',
	#instVars : [
		'pathIDColorDictionary'
	],
	#classVars : [
		'PathIDCache',
		'PathIDColorDictionary'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'cleanup' }
WSTileVisitor class >> clearCache [ 

	^ self subclassResponsibility 
]

{ #category : 'colors' }
WSTileVisitor class >> createColorWheelWithSize: aNumber [
	"Create a color wheel with the given size and then shuffles it"

	^ (((Color wheel: aNumber) asOrderedCollection) shuffled).
]

{ #category : 'accessing' }
WSTileVisitor class >> pathIDCache [

	^ PathIDCache
]

{ #category : 'accessing' }
WSTileVisitor class >> pathIDCache: anObject [

	^ PathIDCache := anObject 
]

{ #category : 'accessing' }
WSTileVisitor class >> pathIDColorDictionary [

	^ PathIDColorDictionary
]

{ #category : 'accessing' }
WSTileVisitor class >> pathIDColorDictionary: anObject [

	PathIDColorDictionary := anObject
]

{ #category : 'initialization' }
WSTileVisitor class >> resetPathIDColorDictionary [

	self pathIDColorDictionary: nil
]

{ #category : 'instance creation' }
WSTileVisitor class >> withPathIDs: aPathIDsArray [
	
	self clearCache.
	((aPathIDsArray ~= PathIDCache) or: [ PathIDColorDictionary isNil ]) ifTrue: [
		| colorWheel  pcd |
		colorWheel := self createColorWheelWithSize: ((aPathIDsArray size) * 4 / 2).
	
		pcd := Dictionary new.
	
		aPathIDsArray do: [ :eachID | 
			pcd at: eachID put: (colorWheel removeFirst)].
		
		pcd at: WSConfig firstPathSymbol put: Color black.
		pcd at: WSConfig secondPathSymbol put: Color black.
		
		PathIDColorDictionary := pcd.
		PathIDCache := aPathIDsArray 
	].
	^ self new
		pathIDColorDictionary: PathIDColorDictionary 
	
	
]

{ #category : '2Disometric' }
WSTileVisitor >> isometricViewOf2DPoint: aPoint [
	"Given a 2D point, it projects it in an isometric view"
	
	| newX newY |
	
"	newX := (aPoint x - aPoint y) * (3 sqrt / 2).
	newY := (aPoint x + aPoint y) * (1/2)."
	
	newX :=  ((aPoint x + aPoint y) * (30 degreesToRadians cos)).
	newY := ((aPoint y - aPoint x) * (30 degreesToRadians sin)).
	
	^ newX @ newY 
	
	

]

{ #category : '2Disometric' }
WSTileVisitor >> isometricViewOf2DPolygon: aPolygon [
	"Given a 2D polygon from a top view, it projects it in an isometric view"

	| newHexagon newPoints |
	newHexagon := aPolygon.
	newPoints := OrderedCollection new.
	
	newPoints addAll: 
		(aPolygon absolutePoints collect: [ :eachPoint |
			 self isometricViewOf2DPoint: eachPoint ]).
	
	 ^ newHexagon points: newPoints.

]

{ #category : '3Disometric' }
WSTileVisitor >> isometricViewOf3DPoint: aPoint withHeight: aHeight [
	"Given a '2D' (4 @ 10) point, it projects it in a '3D' isometric view with specified height"
	
	| newX newY |
	
"	newX := (aPoint x + aPoint y) * (3 sqrt / 2).
	newY := ((aPoint y - aPoint x) * (1/2)) - aHeight ."
	
	newX :=   ((aPoint x + aPoint y) * (3 sqrt / 2)).
	newY :=  (((aPoint y - aPoint x) * (1/2)) - aHeight) .
	
	^ newX @ newY 
	
	

]

{ #category : 'accessing' }
WSTileVisitor >> pathIDColorDictionary [

	^ pathIDColorDictionary
]

{ #category : 'accessing' }
WSTileVisitor >> pathIDColorDictionary: anObject [

	pathIDColorDictionary := anObject
]
