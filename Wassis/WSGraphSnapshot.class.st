"
Snapshot of a node in a certain moment of the execution
"
Class {
	#name : 'WSGraphSnapshot',
	#superclass : 'WSObject',
	#instVars : [
		'nodes',
		'entropyHeap',
		'numberOfCollapsedNodes'
	],
	#category : 'Wassis-Snapshot',
	#package : 'Wassis',
	#tag : 'Snapshot'
}

{ #category : 'fuel support' }
WSGraphSnapshot class >> fuelIgnoredInstanceVariableNames [

    ^ #('entropyHeap')
]

{ #category : 'accessing' }
WSGraphSnapshot >> entropyHeap [

	^ entropyHeap
]

{ #category : 'accessing' }
WSGraphSnapshot >> entropyHeap: anObject [

	entropyHeap := anObject
]

{ #category : 'accessing' }
WSGraphSnapshot >> nodes [

	^ nodes
]

{ #category : 'accessing' }
WSGraphSnapshot >> nodes: anObject [

	nodes := anObject
]

{ #category : 'accessing' }
WSGraphSnapshot >> numberOfCollapsedNodes [

	^ numberOfCollapsedNodes
]

{ #category : 'accessing' }
WSGraphSnapshot >> numberOfCollapsedNodes: anObject [

	numberOfCollapsedNodes := anObject
]
