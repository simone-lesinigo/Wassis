"
Given a tile, it knows how to visualize it
"
Class {
	#name : 'WSTileVisualizer',
	#superclass : 'WSObject',
	#instVars : [
		'pathIDColorDictionary'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'colors' }
WSTileVisualizer class >> createColorWheelWithSize: aNumber [
	"Create a color wheel with the given size and then shuffles it"

	^ (((Color wheel: aNumber) asOrderedCollection) shuffled).
]

{ #category : 'instance creation' }
WSTileVisualizer class >> withPathIDs: aPathIDsArray [
	
	| colorWheel pathIDColorDictionary |
	
	colorWheel := self createColorWheelWithSize: ((aPathIDsArray size) * 4 / 2).
	
	pathIDColorDictionary := Dictionary new.
	
	aPathIDsArray do: [ :eachID | 
		pathIDColorDictionary at: eachID put: (colorWheel removeFirst)].
	
	^ self new
		pathIDColorDictionary: pathIDColorDictionary 
	
	
]

{ #category : '2Disometric' }
WSTileVisualizer >> isometricViewOf2DPoint: aPoint [
	"Given a 2D point, it projects it in an isometric view"
	
	| newX newY |
	
"	newX := (aPoint x - aPoint y) * (3 sqrt / 2).
	newY := (aPoint x + aPoint y) * (1/2)."
	
	newX :=  ((aPoint x + aPoint y) * (30 degreesToRadians cos)).
	newY := ((aPoint y - aPoint x) * (30 degreesToRadians sin)).
	
	^ newX @ newY 
	
	

]

{ #category : '2Disometric' }
WSTileVisualizer >> isometricViewOf2DPolygon: aPolygon [
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
WSTileVisualizer >> isometricViewOf3DPoint: aPoint withHeight: aHeight [
	"Given a '2D' (4 @ 10) point, it projects it in a '3D' isometric view with specified height"
	
	| newX newY |
	
"	newX := (aPoint x + aPoint y) * (3 sqrt / 2).
	newY := ((aPoint y - aPoint x) * (1/2)) - aHeight ."
	
	newX :=   ((aPoint x + aPoint y) * (3 sqrt / 2)).
	newY :=  (((aPoint y - aPoint x) * (1/2)) - aHeight) .
	
	^ newX @ newY 
	
	

]

{ #category : 'accessing' }
WSTileVisualizer >> pathIDColorDictionary [

	^ pathIDColorDictionary
]

{ #category : 'accessing' }
WSTileVisualizer >> pathIDColorDictionary: anObject [

	pathIDColorDictionary := anObject
]
