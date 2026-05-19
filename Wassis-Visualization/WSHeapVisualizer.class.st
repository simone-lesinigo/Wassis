"
Visualize the heap during the execution
"
Class {
	#name : 'WSHeapVisualizer',
	#superclass : 'WSObject',
	#instVars : [
		'canvas',
		'model',
		'historyHeap'
	],
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'instance creation' }
WSHeapVisualizer class >> withModel: aModel [
	
	^ self basicNew model: aModel; initialize 
]

{ #category : 'visualization' }
WSHeapVisualizer >> buildEdgeFrom: aSource to: aTarget [
	"Build an edge between two shapes"

    ^ RSLine new
        from: aSource;
        to: aTarget;
        attachPoint: RSBorderAttachPoint new;
        color: Color darkGray;
        yourself
]

{ #category : 'visualization' }
WSHeapVisualizer >> buildEdgesFor: nodes heapSize: size [

    | edges |
    edges := OrderedCollection new.
    1 to: size do: [ :i |
        | leftIndex rightIndex |
        leftIndex  := 2 * i.
        rightIndex := 2 * i + 1.
        leftIndex <= size ifTrue: [
            edges add: (self buildEdgeFrom: (nodes at: i) to: (nodes at: leftIndex)) ].
        rightIndex <= size ifTrue: [
            edges add: (self buildEdgeFrom: (nodes at: i) to: (nodes at: rightIndex)) ] ].
    ^ edges
]

{ #category : 'visualization' }
WSHeapVisualizer >> buildHeapNodeCompositeFor: aNode [
	 "Build the composites for a single node in the heap"
	
    | box posLabel entropyLabel composite |
    box := RSBox new
        width: 80; height: 50;
        color: Color lightBlue;
        borderColor: Color black;
        borderWidth: 1;
        yourself.
    posLabel := RSLabel new
        text: 'pos: ' , aNode position printString;
        fontSize: 9;
        color: Color black;
        yourself.
    entropyLabel := RSLabel new
        text: 'e: ' , (aNode entropy printShowingDecimalPlaces: 2);
        fontSize: 9;
        color: Color black;
        yourself.
    composite := RSComposite new
        add: box;
        add: posLabel;
        add: entropyLabel;
        adjustToChildren;
        yourself.
    posLabel translateBy: 0 @ -8.
    entropyLabel translateBy: 0 @ 8.
    ^ composite
]

{ #category : 'accessing' }
WSHeapVisualizer >> canvas [

	^ canvas
]

{ #category : 'accessing' }
WSHeapVisualizer >> canvas: anObject [

	canvas := anObject
]

{ #category : 'accessing' }
WSHeapVisualizer >> historyHeap [

	^ historyHeap
]

{ #category : 'accessing' }
WSHeapVisualizer >> historyHeap: anObject [

	historyHeap := anObject
]

{ #category : 'initialization' }
WSHeapVisualizer >> initialize [ 	
	
	super initialize.
	self canvas: RSCanvas new.
	self canvas @ RSCanvasController.
	self historyHeap: model solver executionHistory historyOfMinEntropyHeap.
	self updateHeapAtCurrentIndex.
	self subscribeToEvents.
]

{ #category : 'accessing' }
WSHeapVisualizer >> model [

	^ model
]

{ #category : 'accessing' }
WSHeapVisualizer >> model: anObject [

	model := anObject
]

{ #category : 'initialization' }
WSHeapVisualizer >> onEmptyHeap [
	"Inform the user that the heap is empty"
    | box label composite |
    canvas clearShapes.
    box := RSBox new
        width: 200; height: 60;
        color: (Color r: 0.95 g: 0.95 b: 0.95);
        borderColor: Color gray;
        borderWidth: 1;
        yourself.
    label := RSLabel new
        text: 'Heap is empty';
        fontSize: 14;
        color: Color gray;
        yourself.
    composite := RSComposite new
        add: box;
        add: label;
        adjustToChildren;
        yourself.
    canvas add: composite.
    canvas invalidate; zoomToFit.
]

{ #category : 'initialization' }
WSHeapVisualizer >> subscribeToEvents [

    model announcer
        when: WSAnimationIndexChanged
        do: [ self updateHeapAtCurrentIndex ]
        for: self.

    model announcer
        when: WSHeapPresenterClosed
        do: [ model announcer unsubscribe: self ]
        for: self.
]

{ #category : 'visualization' }
WSHeapVisualizer >> updateHeapAtCurrentIndex [
	"Choose the correct visualization for the current index"

    model index = model maxIndex
        ifTrue: [ self onEmptyHeap ]
        ifFalse: [ self visualizeHeap: (historyHeap at: model index + 1) ]
]

{ #category : 'visualization' }
WSHeapVisualizer >> visualizeHeap: aHeap [
    "Given a min heap, visualizes it as a tree on the canvas"
    | nodes edges |
    canvas clearShapes.
    nodes := aHeap collectWithIndex: [ :node :i |
        | composite |
        composite := self buildHeapNodeCompositeFor: node.
        canvas add: composite.
        composite ].
    
    edges := self buildEdgesFor: nodes heapSize: aHeap size.
    canvas addAll: edges.
    RSTreeLayout new on: canvas nodes.
    canvas invalidate; zoomToFit.
]
