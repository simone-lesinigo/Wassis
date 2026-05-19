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
RSCanvas >> clearShapes [

	self shapes do: #remove.
	self signalUpdate
]
