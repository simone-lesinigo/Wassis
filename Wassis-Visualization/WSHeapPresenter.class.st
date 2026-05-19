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
	self updateWindowTitle.
	self applyLayout.
	
	model announcer 
		when: WSAnimationIndexChanged 
		do: [self updateWindowTitle ]
		for: self
	
	
	
	
]

{ #category : 'initialization' }
WSHeapPresenter >> initializeWindow: aWindow [
    super initializeWindow: aWindow.
    aWindow whenClosedDo: [ 
        model announcer announce: WSHeapPresenterClosed ]
]

{ #category : 'activation' }
WSHeapPresenter >> updateWindowTitle [ 
	
	self windowTitle: ('Heap Visualization at step {1}' format: { model index }).
]
