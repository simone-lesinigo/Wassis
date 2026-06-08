"
Represents a path between two classes on the graph
"
Class {
	#name : 'WSPath',
	#superclass : 'WSObject',
	#instVars : [
		'nodes',
		'length',
		'firstNodes',
		'lastNodes',
		'pathID',
		'sourceClasses',
		'destinationClasses',
		'touchedClasses',
		'efficiency',
		'shortestPath'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'creation' }
WSPath class >> withID: anID [
	
	^ self new pathID: anID
]

{ #category : 'adding' }
WSPath >> addDestinationClass: aNode [

    self destinationClasses add: aNode.
]

{ #category : 'adding' }
WSPath >> addFirstNode: aNode [
	
	self firstNodes add: aNode
]

{ #category : 'adding' }
WSPath >> addLastNode: aNode [
	
	self lastNodes add: aNode
]

{ #category : 'adding' }
WSPath >> addNode: aNode [

	self nodes add: aNode
]

{ #category : 'adding' }
WSPath >> addSourceClass: aNode [

    self sourceClasses add: aNode.
]

{ #category : 'adding' }
WSPath >> addTouchedClass: aNode [

	self touchedClasses add: aNode
]

{ #category : 'converting' }
WSPath >> asOrderedCollection [
	
	self nodes: self nodes asOrderedCollection 
]

{ #category : 'as yet unclassified' }
WSPath >> assignArrowDirections [
	"Assign the direction in which the arrow should be"

		self lastNodes do: [ :eachLastNode |
			| edge |
			edge := eachLastNode outgoingEdges detect: [ :eachEdge | eachEdge target isClassNode ] ifNone: [ nil ].
			eachLastNode tileInWhichCollapsed arrowInDirection: edge direction.
		]
]

{ #category : 'private' }
WSPath >> computeLength [

	self length: self nodes size
]

{ #category : 'accessing' }
WSPath >> crossingNodes [
	
	^ self nodes select: #isCrossingNode
]

{ #category : 'accessing' }
WSPath >> destinationClasses [

	^ destinationClasses 
]

{ #category : 'accessing' }
WSPath >> destinationClasses: anObject [

	destinationClasses  := anObject
]

{ #category : 'accessing' }
WSPath >> efficiency [

	^ efficiency
]

{ #category : 'accessing' }
WSPath >> efficiency: anObject [

	efficiency := anObject
]

{ #category : 'accessing' }
WSPath >> firstNodes [

	^ firstNodes
]

{ #category : 'accessing' }
WSPath >> firstNodes: anObject [

	firstNodes := anObject
]

{ #category : 'testing' }
WSPath >> includes: aNode [ 
	
	^ self nodes includes: aNode 
]

{ #category : 'initialization' }
WSPath >> initialize [ 
	 super initialize.
	 self nodes: IdentitySet new.
	 self sourceClasses: OrderedCollection new.
	 self destinationClasses: OrderedCollection new.
	 self touchedClasses: OrderedCollection new.
	 self firstNodes: OrderedCollection new.
	 self lastNodes: OrderedCollection new.
]

{ #category : 'accessing' }
WSPath >> lastNodes [

	^ lastNodes
]

{ #category : 'accessing' }
WSPath >> lastNodes: anObject [

	lastNodes := anObject
]

{ #category : 'accessing' }
WSPath >> length [

	^ length
]

{ #category : 'accessing' }
WSPath >> length: anObject [

	length := anObject
]

{ #category : 'accessing' }
WSPath >> nodes [

	^ nodes
]

{ #category : 'accessing' }
WSPath >> nodes: anObject [

	nodes := anObject
]

{ #category : 'accessing' }
WSPath >> pathID [

	^ pathID
]

{ #category : 'accessing' }
WSPath >> pathID: anObject [

	pathID := anObject
]

{ #category : 'accessing' }
WSPath >> shortestPath [

	^ shortestPath
]

{ #category : 'accessing' }
WSPath >> shortestPath: anObject [

	shortestPath := anObject
]

{ #category : 'accessing' }
WSPath >> sourceClasses [

	^ sourceClasses 
]

{ #category : 'accessing' }
WSPath >> sourceClasses: anObject [

	sourceClasses  := anObject
]

{ #category : 'accessing' }
WSPath >> touchedClasses [

	^ touchedClasses
]

{ #category : 'accessing' }
WSPath >> touchedClasses: anObject [

	touchedClasses := anObject
]
