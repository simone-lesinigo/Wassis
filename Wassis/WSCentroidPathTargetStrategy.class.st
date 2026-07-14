"
Assign as a target for a path of a class the centroid node of all the classes that share the same pathID
"
Class {
	#name : 'WSCentroidPathTargetStrategy',
	#superclass : 'WSPathTargetStrategy',
	#instVars : [
		'pathIDToCentroid'
	],
	#category : 'Wassis-Path Target',
	#package : 'Wassis',
	#tag : 'Path Target'
}

{ #category : 'calculating' }
WSCentroidPathTargetStrategy >> calculcateCentroidFor: aPathID topology: aTopology [
	"Calulcate the centroid node for all the classes that share the same pathID"
	
	| classes |
	classes := aTopology swSystem allClassesConnectedByPathID: aPathID.
		
	^ aTopology centroidNodeForClasses: classes
]

{ #category : 'finding' }
WSCentroidPathTargetStrategy >> findTargetNodeFor: aClass pathID: aPathID node: aNode topology: aTopology [
	
	^ self pathIDToCentroid at: aPathID ifAbsentPut: [ self calculcateCentroidFor: aPathID topology: aTopology ]

		
	
]

{ #category : 'initialization' }
WSCentroidPathTargetStrategy >> initialize [ 
	
	super initialize.
	self pathIDToCentroid: Dictionary new.
]

{ #category : 'accessing' }
WSCentroidPathTargetStrategy >> pathIDToCentroid [

	^ pathIDToCentroid
]

{ #category : 'accessing' }
WSCentroidPathTargetStrategy >> pathIDToCentroid: anObject [

	pathIDToCentroid := anObject
]
