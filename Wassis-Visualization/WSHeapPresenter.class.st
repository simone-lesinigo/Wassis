"
Presenter used to visualize the heap
"
Class {
	#name : 'WSHeapPresenter',
	#superclass : 'WSModelPresenter',
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'initialization' }
WSHeapPresenter >> applyLayout [ 
	layout := SpBoxLayout newVertical
        add: roassalPresenter expand: true;
        yourself
]

{ #category : 'initialization' }
WSHeapPresenter >> initializePresenter [
	
	super initializePresenter.
	self windowTitle: 'Heap Visualization'.
	self applyLayout.
	
	
]
