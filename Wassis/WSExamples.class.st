"
Provides examples of use
"
Class {
	#name : 'WSExamples',
	#superclass : 'WSObject',
	#category : 'Wassis-Examples',
	#package : 'Wassis',
	#tag : 'Examples'
}

{ #category : 'WSEdge' }
WSExamples class >> exampleCreateEdge [
	"Create and edge between two nodes"
	| n1 n2 edge1 edge2|
	
	n1 := WSNode new.
	n2 := WSNode new.
	
	edge1 := WSEdge new
		source: n1;
		target: n2;
		direction: #up.
	
	edge2 := WSEdge new
		source: n2;
		target: n1;
		direction: #down.
		
	edge1 reverseEdge: edge2.
	edge2 reverseEdge: edge1
]

{ #category : 'WSNode' }
WSExamples class >> exampleCreateNodes [
	"Create two nodes linked to each other"
	| n1 n2 edge1 edge2|
	
	n1 := WSNode new.
	n2 := WSNode new.
	
	edge1 := WSEdge new
		source: n1;
		target: n2;
		direction: #up.
	
	edge2 := WSEdge new
		source: n2;
		target: n1;
		direction: #down.
		
	edge1 reverseEdge: edge2.
	edge2 reverseEdge: edge1.
	
	n1 outgoingEdges: { edge1 }.
	n2 outgoingEdges: { edge2 }.
]

{ #category : 'WSTile' }
WSExamples class >> exampleCreateTile [
	"Create a tile and returns it"
	
	| tile edges |
	
	edges := Dictionary new
		at: #up put: (Array with: '11' asSymbol);
		at: #left put: (Array with: '00' asSymbol);
		at: #right put: (Array with: '00' asSymbol);
		at: #down put: (Array with: '11' asSymbol).
	
	tile := WSTile new
		id: 1;
		edges: edges;
		weight: 10;
		form: Form new
]

{ #category : 'finding' }
WSExamples class >> exampleGetClasses [
	| res |
	res := OrderedCollection new.
	ProtoObject withAllSuperAndSubclassesDo: [ :eachClass |
	    | sw connections |
	    sw := WSSoftwareSystem 
	        createForClass: eachClass 
	        usingStrategy: WSHierarchyClassCollector new.
	    connections := sw allConnectionsPerClass.
	    
	    ((sw classes size between: 15 and: 30) 
	    	and: [ (connections allSatisfy: [ :row | row value size < 4 ])  
		 		and: [ (connections select: [ :row | row value size > 2 ]) size >= 4 ] 
			]
		) ifTrue: [ res add: eachClass ] ].
	
	res inspect
]

{ #category : 'WSAdaptiveSolver' }
WSExamples class >> exampleLoadSolutionFromFile [

	| adaptiveSolver |
	adaptiveSolver := WSAdaptiveSolver loadFromFile: '/Users/Simo/Desktop/Wassis/solutions/solution-07-04-2026_13h36m21s.fuel'.
	adaptiveSolver inspect
]

{ #category : 'WSSolver' }
WSExamples class >> exampleRunHexagonalGrid [
| class1 class2 class3 class4 class5 class6 entities solver graphVisualizer |
	class1 := WSClass new
		          id: 1;
		          connectedWith: { 2. "5" }.

	class2 := WSClass new
		          id: 2;
		          connectedWith: { 1. 4. }.

	class3 := WSClass new
		          id: 3;
		          connectedWith: { 4 . "6" }.

	class4 := WSClass new
		          id: 4;
		          connectedWith: { 2. 3 }.

	class5 := WSClass new
		          id: 5;
		          connectedWith: { 1 }.

	class6 := WSClass new
		          id: 6;
		          connectedWith: { 3 }.
	
	entities := WSSoftwareSystem new 
		addClasses: { class1. class2. class3. class4 . "class5. class6" }.
	
	solver := WSSolver 
		withTopology: (WS2DHexGridTopology withGrid: 15 @ 15) 
		andSwSystem: entities.
	
	graphVisualizer := WSClassesGraphVisualizer new 
		classesArray: (entities classes);
		createVisualization.
		
	solver run.
]

{ #category : 'WSSolver' }
WSExamples class >> exampleRunRectangularGrid [

	| swSystem adaptiveSolver |

	swSystem := WSSoftwareSystem 
		createForClass: Delay 
		usingStrategy: WSHierarchyClassCollector new.

	adaptiveSolver := 
		WSAdaptive2DGridSolver 
			withTopology: WS2DRectangularGridTopology 
			andSwSystem: swSystem.
	
	adaptiveSolver run
		

]
