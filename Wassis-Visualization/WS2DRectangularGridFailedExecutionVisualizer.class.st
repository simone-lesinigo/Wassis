Class {
	#name : 'WS2DRectangularGridFailedExecutionVisualizer',
	#superclass : 'WS2DRectangularGridVisualizer',
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'adding' }
WS2DRectangularGridFailedExecutionVisualizer >> addClickTo: aShape [
	"Reduced interaction on purpose"
	
	aShape
		when: RSMouseLeftClick 
		do: [ (self shapesNodes at: aShape) inspect ]
		for: self.
	
]

{ #category : 'visualization' }
WS2DRectangularGridFailedExecutionVisualizer >> visualizeFailedExecution: aFailedExecution [
	
	self tileVisitor: aFailedExecution tileVisitor.
	canvas 
		addAll: (aFailedExecution copyOfNodes collect: [ :eachNode | self createShapeFor: eachNode ]);	
		addBorderWithColor: Color black andWidth: 20;
		addGridLabelsWithTileSize: self tileVisitor class tileSize 
			withDimension: aFailedExecution dimension first @ aFailedExecution dimension last.

	^ canvas 
]
