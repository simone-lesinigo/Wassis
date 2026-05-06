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

{ #category : 'accessing' }
WS2DSquareVisitor class >> formCache [

	formCache ifNil: [ formCache := Dictionary new ].
	
	^ formCache 
]

{ #category : 'accessing' }
WS2DSquareVisitor class >> formCache: anObject [

	formCache := anObject
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

{ #category : 'drawing' }
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

{ #category : 'drawing' }
WS2DSquareVisitor class >> renderFormForID: aPathTileID withColors: aColorsArr [
	"Create the form for a path tile"

	^ self formCache at: aPathTileID -> aColorsArr ifAbsentPut: [
			  | originalForm form colorsToReplace |
			
			  (aPathTileID between: 1 and: 11) ifTrue: [ colorsToReplace := { Color black } ].
			  aPathTileID = 12 ifTrue: [ colorsToReplace := { Color blue. Color red } ].
			  (#( 13 14 ) includes: aPathTileID) ifTrue: [ colorsToReplace := { Color black. Color red } ].

			  originalForm := self originalPathFormCache at: aPathTileID.
			  form := self
				          colorizePathForm: originalForm
				          replacingColors: colorsToReplace
				          withColors: aColorsArr.
			  form ]
]

{ #category : 'drawing' }
WS2DSquareVisitor class >> renderSolidFormWithColor: aColor [
	"Generate a square filled with aColor"
	
    | standardForm formSize |
	 formSize := self tileSize.
    standardForm := Form extent: formSize @ formSize depth: 32.
    
    standardForm fillColor: aColor.

"	 aColor = Color white ifTrue: [ 
        standardForm border: standardForm boundingBox width: 1 fillColor: Color black 
    ]."
    
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
