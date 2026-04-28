"
Returns the form to visualize a suqare tile
"
Class {
	#name : 'WS2DSquareVisitor',
	#superclass : 'WSTileVisitor',
	#classInstVars : [
		'formCache',
		'originalPathFormCache'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'cleanup' }
WS2DSquareVisitor class >> clearCache [
	
	self formCache: nil.
	self originalPathFormCache: nil.
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> colorizePathForm: aOriginalPathForm replacingColors: sourceColors withColors: targetColors [
    "Replace each color in sourceColors with the corresponding color in targetColors"
    
    | copy colorMap |
    copy := aOriginalPathForm deepCopy.
    colorMap := Dictionary new.
    sourceColors doWithIndex: [ :srcColor :i |
        colorMap at: srcColor put: (targetColors at: i) ].
    
    0 to: copy height - 1 do: [ :y |
        0 to: copy width - 1 do: [ :x |
            | pixel replacement |
            pixel := copy colorAt: x @ y.
            replacement := colorMap at: pixel ifAbsent: [ nil ].
            replacement ifNotNil: [ copy colorAt: x @ y put: replacement ] ] ].
    ^ copy
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawCrossingOn: canvas size: s c1: colorVertical c2: colorHorizontal [
    "Disegna un incrocio con un quadrato nero centrale"
    
    "1. Rettangolo verticale (primo colore)"
    canvas setPaint: colorVertical.
    canvas drawShape: (0.4 * s @ 0 extent: 0.2 * s @ s).
    
    "2. Rettangolo orizzontale (secondo colore)"
    canvas setPaint: colorHorizontal.
    canvas drawShape: (0 @ 0.4 * s extent: s @ 0.2 * s).
    
    "3. Quadrato centrale (Nero)"
    canvas setPaint: Color black.
    canvas drawShape: (0.4 * s @ 0.4 * s extent: 0.2 * s @ 0.2 * s).
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawDoubleCornerAOn: canvas size: s c1: c1 c2: c2 [
    | cx cy rR rS |

    rR := s * 0.4. "40"
    rS := s * 0.2. "20"

    "PATH 1 (alto-destra)"
    canvas setPaint: c1.
    canvas drawShape: (canvas createPath: [ :b |
        b absolute.

        b moveTo: s @ (s * 0.6).
        b lineTo: (s * 0.8) @ (s * 0.6).

        "big arc center (80,20) from 90° to 180°"
        cx := s * 0.8.
        cy := s * 0.2.
        b lineTo: (cx + (rR * ((Float pi * 0.5) cos)))
              @ (cy + (rR * ((Float pi * 0.5) sin))).
        b arcAround: cx @ cy
            radius: rR
            startAngle: (Float pi * 0.5)
            endAngle: Float pi.

        b lineTo: (s * 0.4) @ 0.
        b lineTo: (s * 0.6) @ 0.
        b lineTo: (s * 0.6) @ (s * 0.2).

        "small arc center (80,40) from 270° to 0°"
        cx := s * 0.8.
        cy := s * 0.4.
        b lineTo: (cx + (rS * ((Float pi * 1.5) cos)))
              @ (cy + (rS * ((Float pi * 1.5) sin))).
        b arcAround: cx @ cy
            radius: rS
            startAngle: (Float pi * 1.5)
            endAngle: 0.

        b lineTo: s @ (s * 0.4).
        b closePath ]).


    "PATH 2 (basso-sinistra)"
    canvas setPaint: c2.
    canvas drawShape: (canvas createPath: [ :b |
        b absolute.

        b moveTo: 0 @ (s * 0.4).
        b lineTo: (s * 0.2) @ (s * 0.4).

        "big arc center (20,80) from 270° to 0°"
        cx := s * 0.2.
        cy := s * 0.8.
        b lineTo: (cx + (rR * ((Float pi * 1.5) cos)))
              @ (cy + (rR * ((Float pi * 1.5) sin))).
        b arcAround: cx @ cy
            radius: rR
            startAngle: (Float pi * 1.5)
            endAngle: 0.

        b lineTo: (s * 0.6) @ s.
        b lineTo: (s * 0.4) @ s.
        b lineTo: (s * 0.4) @ (s * 0.8).

        "small arc center (20,60) from 90° to 180°"
        cx := s * 0.2.
        cy := s * 0.6.
        b lineTo: (cx + (rS * ((Float pi * 0.5) cos)))
              @ (cy + (rS * ((Float pi * 0.5) sin))).
        b arcAround: cx @ cy
            radius: rS
            startAngle: (Float pi * 0.5)
            endAngle: Float pi.

        b lineTo: 0 @ (s * 0.6).
        b closePath ]).
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawDoubleCornerBOn: canvas size: s c1: c1 c2: c2 [
    "Tile 14"

    canvas setPaint: c1.
    canvas drawShape: (canvas createPath: [ :b |
        b absolute.

        "M60 0 V20"
        b moveTo: (s*0.6) @ 0.
        b lineTo: (s*0.6) @ (s*0.2).

        "A40 40 -> to (0,60)"
        b arcTo: 0 @ (s*0.6) angle: Float pi cw: false.

        "H0 V40 H20"
        b lineTo: 0 @ (s*0.4).
        b lineTo: (s*0.2) @ (s*0.4).

        "A20 20 -> to (40,20)"
        b arcTo: (s*0.4) @ (s*0.2) angle: (Float pi * 0.5) cw: true.

        "V0 Z"
        b lineTo: (s*0.4) @ 0.
        b lineTo: (s*0.6) @ 0.
        b closePath ]).


    canvas setPaint: c2.
    canvas drawShape: (canvas createPath: [ :b |
        b absolute.

        "M40 100 V80"
        b moveTo: (s*0.4) @ s.
        b lineTo: (s*0.4) @ (s*0.8).

        "A40 40 -> to (100,40)"
        b arcTo: s @ (s*0.4) angle: Float pi cw: false.

        "H100 V60 H80"
        b lineTo: s @ (s*0.6).
        b lineTo: (s*0.8) @ (s*0.6).

        "A20 20 -> to (60,80)"
        b arcTo: (s*0.6) @ (s*0.8) angle: (Float pi * 0.5) cw: true.

        "V100 Z"
        b lineTo: (s*0.6) @ s.
        b lineTo: (s*0.4) @ s.
        b closePath ]).
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawInstructionsFor: aPathTileID on: aBuilder size: aSize [

    | selector |
    selector := ('drawPath' , aPathTileID asString , 'On:size:') asSymbol.
    
	^ self perform: selector with: aBuilder with: aSize 

]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath10On: b size: s [

	b absolute;
		moveTo: 0 @ (s * 0.4);
		lineTo: s @ (s * 0.4);
		lineTo: s @ (s * 0.6);
		lineTo: 0 @ (s * 0.6);
		closePath;
		moveTo: (s * 0.4) @ (s * 0.6);
		lineTo: (s * 0.6) @ (s * 0.6);
		lineTo: (s * 0.6) @ s;
		lineTo: (s * 0.4) @ s;
		closePath
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath11On: b size: s [

	b absolute;
		moveTo: (s * 0.4) @ 0;
		lineTo: (s * 0.6) @ 0;
		lineTo: (s * 0.6) @ s;
		lineTo: (s * 0.4) @ s;
		closePath;
		moveTo: 0 @ (s * 0.4);
		lineTo: s @ (s * 0.4);
		lineTo: s @ (s * 0.6);
		lineTo: 0 @ (s * 0.6);
		closePath
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath12On: b size: s [

	b absolute;
		moveTo: (s * 0.4) @ 0;
		lineTo: (s * 0.6) @ 0;
		lineTo: (s * 0.6) @ s;
		lineTo: (s * 0.4) @ s;
		closePath;
		moveTo: 0 @ (s * 0.4);
		lineTo: s @ (s * 0.4);
		lineTo: s @ (s * 0.6);
		lineTo: 0 @ (s * 0.6);
		closePath
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath1On: b size: s [
    
	b absolute;
   		moveTo: 0 @ (s * 0.4);
      lineTo: s @ (s * 0.4);
      lineTo: s @ (s * 0.6);
      lineTo: 0 @ (s * 0.6);
      closePath
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath2On: b size: s [

   b absolute;
   		moveTo: (s * 0.4) @ 0;
      lineTo: (s * 0.6) @ 0;
      lineTo: (s * 0.6) @ s;
      lineTo: (s * 0.4) @ s;
      closePath
]

{ #category : 'deprecated' }
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

{ #category : 'deprecated' }
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

{ #category : 'deprecated' }
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

{ #category : 'deprecated' }
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

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath7On: b size: s [

    b absolute;
        moveTo: (s * 0.4) @ 0;
        lineTo: (s * 0.6) @ 0;
        lineTo: (s * 0.6) @ s;
        lineTo: (s * 0.4) @ s;
        closePath;

        moveTo: 0 @ (s * 0.4);
        lineTo: (s * 0.4) @ (s * 0.4);
        lineTo: (s * 0.4) @ (s * 0.6);
        lineTo: 0 @ (s * 0.6);
        closePath
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath8On: b size: s [

    b absolute;
        moveTo: (s * 0.4) @ 0;
        lineTo: (s * 0.6) @ 0;
        lineTo: (s * 0.6) @ s;
        lineTo: (s * 0.4) @ s;
        closePath;
        moveTo: (s * 0.6) @ (s * 0.4);
        lineTo: s @ (s * 0.4);
        lineTo: s @ (s * 0.6);
        lineTo: (s * 0.6) @ (s * 0.6);
        closePath
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> drawPath9On: b size: s [

	b absolute;
		moveTo: 0 @ (s * 0.4);
		lineTo: s @ (s * 0.4);
		lineTo: s @ (s * 0.6);
		lineTo: 0 @ (s * 0.6);
		closePath;
		moveTo: (s * 0.4) @ 0;
		lineTo: (s * 0.6) @ 0;
		lineTo: (s * 0.6) @ (s * 0.4);
		lineTo: (s * 0.4) @ (s * 0.4);
		closePath
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> formCache [

	formCache ifNil: [ formCache := Dictionary new ].
	
	^ formCache 
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> formCache: anObject [

	formCache := anObject
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> generateFormForID: aPathTileID withColor: aColor [
	"Generate the correct path form based on the ID"
	
	^ self formCache at: aPathTileID -> aColor ifAbsentPut: [
		| form |
		form := self renderFormForID: aPathTileID withColor: aColor.
		form ]
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> generateSolidFormWithColor: aColor [
	
	^ self formCache at: aColor ifAbsentPut: [ 		
		| form |
		form := self renderSolidFormWithColor: aColor.
		form  ]
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> loadOriginalPathForms [
    
    1 to: 14 do: [ :id |
        | path form |
        path := '' join: {WSObject rootPath . 'tiles/rectangularGrid/png/'. id printString. '.png'}.
        form := ImageReadWriter formFromFileNamed: path.
		  form := form scaledToSize: (self tileSize @ self tileSize).
        self originalPathFormCache at: id put: form ]
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> originalPathFormCache [

	originalPathFormCache ifNil: [ 
		originalPathFormCache := Dictionary new. 
		self loadOriginalPathForms 
	].
	
	^ originalPathFormCache 
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> originalPathFormCache: anObject [

	originalPathFormCache := anObject
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> renderCrossingFormForID: aPathTileID withColor: aColor andColor: aSecondColor [
    | surface standardForm formSize half thickness |
    formSize := self tileSize.
    half := formSize / 2.
    thickness := formSize * 0.2. 
    
    surface := AthensCairoSurface extent: formSize @ formSize.
    surface drawDuring: [ :canvas |
        "Sfondo bianco"
        canvas setPaint: Color white.
        canvas drawShape: (0 @ 0 extent: formSize @ formSize).
        
        "Rettangolo verticale - primo colore"
        canvas setPaint: aColor.
        canvas drawShape: ((canvas createPath: [ :b |
            b absolute;
                moveTo: (formSize * 0.4) @ 0;
                lineTo: (formSize * 0.6) @ 0;
                lineTo: (formSize * 0.6) @ formSize;
                lineTo: (formSize * 0.4) @ formSize;
                closePath ])).
        
        "Rettangolo orizzontale - secondo colore"
        canvas setPaint: aSecondColor.
        canvas drawShape: (canvas createPath: [ :b |
            b absolute;
                moveTo: 0 @ (formSize * 0.4);
                lineTo: formSize @ (formSize * 0.4);
                lineTo: formSize @ (formSize * 0.6);
                lineTo: 0 @ (formSize * 0.6);
                closePath ]).
        
        "Quadrato centrale - nero"
        canvas setPaint: Color black.
        canvas drawShape: (canvas createPath: [ :b |
            b absolute;
                moveTo: (formSize * 0.4) @ (formSize * 0.4);
                lineTo: (formSize * 0.6) @ (formSize * 0.4);
                lineTo: (formSize * 0.6) @ (formSize * 0.6);
                lineTo: (formSize * 0.4) @ (formSize * 0.6);
                closePath ]).
    ].
    
    standardForm := Form extent: formSize @ formSize depth: 32.
    surface asForm displayOn: standardForm.
    ^ standardForm
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> renderFormForID: aPathTileID withColor: aColor [
	"Create the form for a path tile"
	
	^ self formCache at: (aPathTileID -> { aColor }) ifAbsentPut: [ 		
		| originalForm form |
		originalForm := self originalPathFormCache at: aPathTileID.
		form := self 
			colorizePathForm: originalForm 
			replacingColors: { Color black } 
			withColors: { aColor }.
		form  ]
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> renderFormForID: aPathTileID withColors: aColorsArr [
	"Create the form for a path tile"

	^ self formCache at: aPathTileID -> aColorsArr ifAbsentPut: [
			  | originalForm form colorsToReplace |
			
			  (aPathTileID between: 1 and: 11) ifTrue: [ colorsToReplace := { Color black } ].
			  aPathTileID = 12 ifTrue: [ colorsToReplace := { Color red. Color blue } ].
			  (#( 13 14 ) includes: aPathTileID) ifTrue: [ colorsToReplace := { Color black. Color red } ].

			  originalForm := self originalPathFormCache at: aPathTileID.
			  form := self
				          colorizePathForm: originalForm
				          replacingColors: colorsToReplace
				          withColors: aColorsArr.
			  form ]
]

{ #category : 'deprecated' }
WS2DSquareVisitor class >> renderMultiColorFormForID: anId withColors: aCollectionOfColors [

    | surface formSize color1 color2 |
    formSize := self tileSize.
    color1 := aCollectionOfColors first.
    color2 := aCollectionOfColors second.
    
    surface := AthensCairoSurface extent: formSize @ formSize.
    surface drawDuring: [ :canvas |
        canvas setPaint: Color white.
        canvas drawShape: (0 @ 0 extent: formSize @ formSize).
        
        anId = 12 ifTrue: [ self drawCrossingOn: canvas size: formSize c1: color1 c2: color2 ].
        anId = 13 ifTrue: [ self drawDoubleCornerAOn: canvas size: formSize c1: color1 c2: color2 ].
        anId = 14 ifTrue: [ self drawDoubleCornerBOn: canvas size: formSize c1: color1 c2: color2 ].
    ].
    ^ surface asForm
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> renderSolidFormWithColor: aColor [
	"Generate a square filled with aColor"
	
    | standardForm formSize |
	 formSize := self tileSize.
    standardForm := Form extent: formSize @ formSize depth: 32.
    
    standardForm fillColor: aColor.

	 aColor = Color white ifTrue: [ 
        standardForm border: standardForm boundingBox width: 1 fillColor: Color black 
    ].
    
    ^ standardForm
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> tileSize [

	^ WS2DRectangularGridConfig squareVisitorTileSize
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

	| shape normalForm highlightedForm colors |
	shape := RSBitmap new.
	colors := OrderedCollection new.
	colors addAll: (pathTile pathIDs collect: [ :eachPathID | self pathIDColorDictionary at: eachPathID ]).

	normalForm := self class renderFormForID: pathTile id withColors: colors.

	highlightedForm := self class renderFormForID: pathTile id withColors: (Array new: colors size withAll: Color black).

	shape form: normalForm.
	shape propertyAt: #normalForm put: normalForm.
	shape propertyAt: #highlightForm put: highlightedForm.

	self addHoverTo: shape.
	^ shape
]

{ #category : 'visiting' }
WS2DSquareVisitor >> visitUncollapsedTile: emptyTile [

	^  RSBitmap new 
			form: (self class generateSolidFormWithColor: Color lightGray)
]
