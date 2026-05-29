Extension { #name : 'RSCanvas' }

{ #category : '*Wassis-Visualization' }
RSCanvas >> addBorderWithColor: aColor andWidth: aWidth [
	"Add a border to the canvas following its encompassing rectangle"
	
	| border bbox |
	bbox := self shapes encompassingRectangle.
   border := RSBox new
   		color: Color transparent;
      borderColor: Color black;
      borderWidth: aWidth ;
      position: bbox center;
      extent: bbox extent + (aWidth * 2);
      yourself.
   self add: border.
	border pushBack.
]

{ #category : '*Wassis-Visualization' }
RSCanvas >> addGridLabelsWithTileSize: aTileSize withDimension: aPoint [
    "Add the numbers of rows and columns wrapping around the content"

    | rect fontSize |
    rect := self nodes encompassingRectangle.
    fontSize := aTileSize * 0.35.
    
    1 to: aPoint y do: [ :col |
        | label |
        label := RSLabel new
            text: col printString;
            fontSize: fontSize;
            yourself.
        self add: label.
        label position: (rect left + (col * aTileSize) - (aTileSize / 2)) @ (rect top - (fontSize)).
    ].
    
    1 to: aPoint x do: [ :row |
        | label |
        label := RSLabel new
            text: row printString;
            fontSize: fontSize;
            yourself.
        self add: label.
        label position: (rect left - fontSize ) @ (rect top + (row * aTileSize) - (aTileSize / 2) ).
    ]
]

{ #category : '*Wassis-Visualization' }
RSCanvas >> clearShapes [

	self shapes do: #remove.
	self signalUpdate
]
