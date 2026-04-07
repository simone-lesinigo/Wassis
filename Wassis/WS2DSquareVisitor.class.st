"
Returns the form to visualize a suqare tile
"
Class {
	#name : 'WS2DSquareVisitor',
	#superclass : 'WSTileVisitor',
	#classInstVars : [
		'pathForms'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'filesPath' }
WS2DSquareVisitor class >> folderPath [

	^ '/Users/Simo/Desktop/Wassis/tiles/rectangularGrid/png' asFileReference 
]

{ #category : 'visualization' }
WS2DSquareVisitor class >> pathFormFor: pathID [

	^ Form fromFileNamed: self folderPath / (pathID asString, '.png').
]

{ #category : 'deprecated' }
WS2DSquareVisitor >> classTileForm [

	^ ((Form fromFileNamed: self class folderPath / 'fullsquare.png') scaledToSize: 50 @ 50)
]

{ #category : 'deprecated' }
WS2DSquareVisitor >> createFormFor: aTile [
	"Given a tile, it returns the correct form"
	
	aTile isEmptyTile ifTrue: [ ^ self emptyTileForm ].
	aTile isPathTile ifTrue: [ ^ self pathTileFormFor: aTile ].
	aTile isClassTile ifTrue: [ ^ self classTileForm ].
]

{ #category : 'deprecated' }
WS2DSquareVisitor >> emptyTileForm [

	^ ((Form fromFileNamed: self class folderPath / 'emptyTile.png') scaledToSize: 50 @ 50)
]

{ #category : 'deprecated' }
WS2DSquareVisitor >> pathTileFormFor: aTile [

	| form folderPath |
	folderPath := self class folderPath.
	
	aTile id = 1 ifTrue: [ form := Form fromFileNamed: folderPath / '1.png' ].
	aTile id = 2 ifTrue: [ form := Form fromFileNamed: folderPath / '2.png' ].
	aTile id = 3 ifTrue: [ form := Form fromFileNamed: folderPath / '3.png' ].
	aTile id = 4 ifTrue: [ form := Form fromFileNamed: folderPath / '4.png' ].
	aTile id = 5 ifTrue: [ form := Form fromFileNamed: folderPath / '5.png' ].
	aTile id = 6 ifTrue: [ form := Form fromFileNamed: folderPath / '6.png' ].
	
	form := form modifyWithColor: (self pathIDColorDictionary at: aTile pathID).
	
	^ form
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitClassTile: classTile [

	^ ((Form fromFileNamed: self class folderPath / 'fullsquare.png') scaledToSize: 50 @ 50)
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitEmptyTile: emptyTile [

	^ ((Form fromFileNamed: self class folderPath / 'emptyTile.png') scaledToSize: 50 @ 50)
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitPathTile: pathTile [
	
	| form |
	
	form := (self class pathFormFor: pathTile id).
	
	^ form modifyWithColor: (self pathIDColorDictionary at: pathTile pathID)
]
