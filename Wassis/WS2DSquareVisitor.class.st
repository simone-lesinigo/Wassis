"
Returns the form to visualize a suqare tile
"
Class {
	#name : 'WS2DSquareVisitor',
	#superclass : 'WSTileVisitor',
	#classInstVars : [
		'formCache'
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

{ #category : 'accessing' }
WS2DSquareVisitor class >> formCache [

	^ formCache ifNil: [ formCache := Dictionary new ]
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> formCache: anObject [

	formCache := anObject
]

{ #category : 'rendering' }
WS2DSquareVisitor class >> generateFormForID: aPathTileID withColor: aColor [
	"Generate the correct path form based on the ID"
	
	^ self formCache at: aPathTileID -> aColor ifAbsentPut: [
		| form |
		form := self renderFormForID: aPathTileID withColor: aColor.
		form ]
]

{ #category : 'rendering' }
WS2DSquareVisitor class >> generateSolidFormWithColor: aColor [
	
	^ self formCache at: aColor ifAbsentPut: [ 		
		| form |
		form := self renderSolidFormWithColor: aColor.
		form  ]
]

{ #category : 'rendering' }
WS2DSquareVisitor class >> renderFormForID: aPathTileID withColor: aColor [
	"Create the form for a path tile"
	
    | surface size standardForm |
    size := 50.
    surface := AthensCairoSurface extent: size @ size.
    surface drawDuring: [ :canvas | | path |
        canvas setPaint: Color white.
        canvas drawShape: (0 @ 0 extent: size @ size).
        path := canvas createPath: [ :builder | 
            self drawInstructionsFor: aPathTileID on: builder size: size ].
        canvas setPaint: aColor.
        canvas drawShape: path.
    ].

    standardForm := Form extent: size @ size depth: 32.
    
    surface asForm displayOn: standardForm.
    
    ^ standardForm
]

{ #category : 'rendering' }
WS2DSquareVisitor class >> renderSolidFormWithColor: aColor [
	"Generate a square filled with aColor"
	
    | size standardForm |
    size := 50.
    standardForm := Form extent: size @ size depth: 32.
    
    standardForm fillColor: aColor.
    
    ^ standardForm
]

{ #category : 'adding' }
WS2DSquareVisitor >> addHoverTo: aShape [

	aShape
		when: RSMouseEnter
		do: [ :evt |
				aShape form: (aShape propertyAt: #highlightForm).
				aShape invalidate ]
		for: self.

	aShape
		when: RSMouseLeave
		do: [ :evt |
				aShape form: (aShape propertyAt: #normalForm).
				aShape invalidate ]
		for: self
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitClassTile: classTile [

	^ RSBitmap new
		form: (self class generateSolidFormWithColor: Color black)
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitEmptyTile: emptyTile [

	^  RSBitmap new 
			form: (self class generateSolidFormWithColor: Color white)
]

{ #category : 'visualization' }
WS2DSquareVisitor >> visitPathTile: pathTile [
	<toDo> "Choose path color based on the type of relation"
	
	| shape normalForm highlightedForm |

	shape := RSBitmap new.
	
	normalForm := (self class 
		generateFormForID: pathTile id 
		withColor: (self pathIDColorDictionary at: pathTile pathID)).
	
	highlightedForm := (self class 
		generateFormForID: pathTile id 
		withColor: Color black).
		
	shape form: normalForm.
	shape propertyAt: #normalForm put: normalForm.
   shape propertyAt: #highlightForm put: highlightedForm.
	
	self addHoverTo: shape.
	
	^ shape
		
	
	
	
]
