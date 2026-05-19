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
	self visualizeHeap: historyHeap first.
	
	model announcer
		when: WSAnimationIndexChanged 
		do: [ self visualizeHeap: (historyHeap at: model index) ]
		for: self
]

{ #category : 'accessing' }
WSHeapVisualizer >> model [

	^ model
]

{ #category : 'accessing' }
WSHeapVisualizer >> model: anObject [

	model := anObject
]

{ #category : 'visualization' }
WSHeapVisualizer >> visualizeHeap: aHeap [
    "Given a min heap, returns a RSCanvas with the tree visualization"
    | nodes edges |
    canvas clearShapes.
    nodes := aHeap collectWithIndex: [ :node :i |
        | composite box label |
        box := RSBox new
            size: 60;
            color: Color lightBlue;
            borderColor: Color black;
            borderWidth: 1;
            yourself.
        label := RSLabel new
            text: node position printString , String cr , 'e:' , (node entropy printShowingDecimalPlaces: 2);
            fontSize: 8;
            color: Color black;
            yourself.
        composite := RSComposite new
            add: box;
            add: label;
            adjustToChildren;
            yourself.
        composite @ (RSPopup new text: 'Position: ' , node position printString , ' Entropy: ' , node entropy printString).
        canvas add: composite.
        composite ].
    
    edges := OrderedCollection new.
    1 to: aHeap size do: [ :i |
        | leftIndex rightIndex |
        leftIndex  := 2 * i.
        rightIndex := 2 * i + 1.
        leftIndex  <= aHeap size ifTrue: [ edges add: (RSLine new from: (nodes at: i); to: (nodes at: leftIndex);  yourself) ].
        rightIndex <= aHeap size ifTrue: [ edges add: (RSLine new from: (nodes at: i); to: (nodes at: rightIndex); yourself) ] ].
    
    canvas addAll: edges.
    RSTreeLayout new on: canvas nodes.
	 canvas invalidate; zoomToFit .
    ^ canvas
]
