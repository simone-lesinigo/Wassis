"
Entry of the heap. It holds a reference to the node and its entropy
"
Class {
	#name : 'WSHeapEntry',
	#superclass : 'WSObject',
	#instVars : [
		'node',
		'entropy'
	],
	#category : 'Wassis-Utility',
	#package : 'Wassis',
	#tag : 'Utility'
}

{ #category : 'instance creation' }
WSHeapEntry class >> fromNodes: aNodesArray [
	
	^ aNodesArray collect: [ :eachNode | self node: eachNode entropy: eachNode entropy ]
]

{ #category : 'instance creation' }
WSHeapEntry class >> node: aNode entropy: anEntropy [

	^ self new
		node: aNode;
		entropy: anEntropy
]

{ #category : 'accessing' }
WSHeapEntry >> entropy [

	^ entropy
]

{ #category : 'accessing' }
WSHeapEntry >> entropy: anObject [

	entropy := anObject
]

{ #category : 'accessing' }
WSHeapEntry >> node [

	^ node
]

{ #category : 'accessing' }
WSHeapEntry >> node: anObject [

	node := anObject
]
