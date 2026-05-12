"
Represents a path between two classes on the graph
"
Class {
	#name : 'WSPath',
	#superclass : 'WSObject',
	#instVars : [
		'nodes',
		'length',
		'firstNode',
		'lastNode',
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
WSPath >> firstNode [

	^ firstNode
]

{ #category : 'accessing' }
WSPath >> firstNode: anObject [

	firstNode := anObject
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
	 self touchedClasses: OrderedCollection new
]

{ #category : 'accessing' }
WSPath >> lastNode [

	^ lastNode
]

{ #category : 'accessing' }
WSPath >> lastNode: anObject [

	lastNode := anObject
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
