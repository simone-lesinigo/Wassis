"
Defines the topology of the graph
"
Class {
	#name : 'WSTopology',
	#superclass : 'WSObject',
	#instVars : [
		'swSystem',
		'oppositeDirections',
		'tileset',
		'visualizer'
	],
	#category : 'Wassis-Topology',
	#package : 'Wassis',
	#tag : 'Topology'
}

{ #category : 'instance creation' }
WSTopology class >> createOppositeDirections [ 

	^ self subclassResponsibility 
]

{ #category : 'directionSymbol' }
WSTopology class >> emptyEdgeSymbol [
	
	^ '00' asSymbol 
]

{ #category : 'accessing' }
WSTopology >> allPathIDs [

	^ self swSystem classesPathIDs
]

{ #category : 'creation' }
WSTopology >> connect: sourceNode to: targetNode withDirection: aDirection [
	"Create the edge and the reverse edge between two nodes and add them to respective nodes"
	
	| edge reverseEdge oppositeDir |
	oppositeDir := self oppositeDirections at: aDirection.
	
	edge := WSEdge 
		withSource: sourceNode 
		withTarget: targetNode 
		withDirection: aDirection.

	reverseEdge := WSEdge 
		withSource: targetNode 
		withTarget:  sourceNode 
		withDirection: oppositeDir.
		
	edge reverseEdge: reverseEdge.
	reverseEdge reverseEdge: edge.
	
	sourceNode addEdge: edge.	
	targetNode addEdge: reverseEdge.
]

{ #category : 'tileset' }
WSTopology >> createAllPathTiles [

	^ self subclassResponsibility 
	
	
]

{ #category : 'tileset' }
WSTopology >> createEmptyTile [

	^ self subclassResponsibility 
	
	
]

{ #category : 'creation' }
WSTopology >> createGraph [
	
	^ self subclassResponsibility 
]

{ #category : 'tileset' }
WSTopology >> createTileset [

	^ self subclassResponsibility 
]

{ #category : 'creation' }
WSTopology >> initializeWith: aSwSystem [

	^ self subclassResponsibility 
	
	
]

{ #category : 'accessing' }
WSTopology >> oppositeDirections [

	^ oppositeDirections
]

{ #category : 'accessing' }
WSTopology >> oppositeDirections: anObject [

	oppositeDirections := anObject
]

{ #category : 'accessing' }
WSTopology >> swSystem [

	^ swSystem
]

{ #category : 'accessing' }
WSTopology >> swSystem: anObject [

	swSystem := anObject
]

{ #category : 'accessing' }
WSTopology >> tileset [

	^ tileset
]

{ #category : 'accessing' }
WSTopology >> tileset: anObject [

	tileset := anObject
]

{ #category : 'accessing' }
WSTopology >> visualizer [

	^ visualizer
]

{ #category : 'accessing' }
WSTopology >> visualizer: anObject [

	visualizer := anObject
]
