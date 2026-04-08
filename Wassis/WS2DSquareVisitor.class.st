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

{ #category : 'rendering' }
WS2DSquareVisitor class >> drawInstructionsFor: aPathTileID on: aBuilder size: aSize [

    | selector |
    selector := ('drawPath' , aPathTileID asString , 'On:size:') asSymbol.
    
	^ self perform: selector with: aBuilder with: aSize 

]

{ #category : 'drawing' }
WS2DSquareVisitor class >> drawPath1On: b size: s [
    
	b absolute;
   		moveTo: 0 @ (s * 0.4);
      lineTo: s @ (s * 0.4);
      lineTo: s @ (s * 0.6);
      lineTo: 0 @ (s * 0.6);
      closePath
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> drawPath2On: b size: s [

   b absolute;
   		moveTo: (s * 0.4) @ 0;
      lineTo: (s * 0.6) @ 0;
      lineTo: (s * 0.6) @ s;
      lineTo: (s * 0.4) @ s;
      closePath
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> drawPath3On: b size: s [
  
    b absolute;
        moveTo: (s * 0.4) @ 0;         
        lineTo: (s * 0.6) @ 0;          
        lineTo: (s * 0.6) @ (s * 0.4);  
        lineTo: s @ (s * 0.4);          
        lineTo: s @ (s * 0.6);          
        lineTo: (s * 0.4) @ (s * 0.6);  
        lineTo: (s * 0.4) @ 0;          
        closePath                       
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> drawPath4On: b size: s [
  
	b absolute;
		moveTo: (s * 0.4) @ 0;
		lineTo: (s * 0.6) @ 0;
		lineTo: (s * 0.6) @ (s * 0.6);
		lineTo: 0 @ (s * 0.6);
		lineTo: 0 @ (s * 0.4);
		lineTo: (s * 0.4) @ (s * 0.4);
		closePath                     
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> drawPath5On: b size: s [
  
	b absolute;
		moveTo: (s * 0.4) @ s;
		lineTo: (s * 0.6) @ s;
		lineTo: (s * 0.6) @ (s * 0.6);
		lineTo: s @ (s * 0.6);
		lineTo: s @ (s * 0.4);
		lineTo: (s * 0.4) @ (s * 0.4);
		closePath                    
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> drawPath6On: b size: s [
  
	b absolute;
		moveTo: (s * 0.4) @ s;
		lineTo: (s * 0.6) @ s;
		lineTo: (s * 0.6) @ (s * 0.4);
		lineTo: 0 @ (s * 0.4);
		lineTo: 0 @ (s * 0.6);
		lineTo: (s * 0.4) @ (s * 0.6);
		closePath                 
]

{ #category : 'rendering' }
WS2DSquareVisitor class >> generateFormForID: aPathID withColor: aColor [
	"Generate the correct form for the path tile with the given ID"
	
    | surface standardForm size |
	 size := 50.
    surface := AthensCairoSurface extent: size @ size.
    
    surface drawDuring: [ :canvas | | path |
        canvas setPaint: Color white.
        canvas drawShape: (0 @ 0 extent: size @ size).

        path := canvas createPath: [ :builder | 
            self drawInstructionsFor: aPathID on: builder size: size].
        
        canvas setPaint: aColor.
        canvas drawShape: path.
    ].

    standardForm := Form extent: size @ size depth: 32.
    
    surface asForm displayOn: standardForm.
    
    ^ standardForm
]

{ #category : 'rendering' }
WS2DSquareVisitor class >> generateSolidFormWithColor: aColor [
	"Generate a square filled with aColor"
	
    | size standardForm |
    size := 50.
    standardForm := Form extent: size @ size depth: 32.
    
    standardForm fillColor: aColor.
    
    ^ standardForm
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> pathForms [

	^ pathForms
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> pathForms: anObject [

	pathForms := anObject
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

	^ self class generateSolidFormWithColor: Color black
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitEmptyTile: emptyTile [

	^ self class generateSolidFormWithColor: Color white
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitPathTile: pathTile [
	
	^ (self class 
		generateFormForID: pathTile id
		withColor: (self pathIDColorDictionary at: pathTile pathID)
	)
]
