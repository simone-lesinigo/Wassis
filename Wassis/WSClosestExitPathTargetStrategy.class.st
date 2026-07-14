"
Selects the closest class to which it should be connected on the grid. Instead of targeting the class node itself, it selects the specific exit node associated with that pathID.
"
Class {
	#name : 'WSClosestExitPathTargetStrategy',
	#superclass : 'WSClosestPathTargetStrategy',
	#category : 'Wassis-Path Target',
	#package : 'Wassis',
	#tag : 'Path Target'
}

{ #category : 'finding' }
WSClosestExitPathTargetStrategy >> targetNodeFor: aClass pathID: aPathID topology: aTopology [
	"Instead of returning the node that share the same pathID as the target, it returns the exit node. If an error occurs, it returns the class node"
	
	| nodeWithSamePathID pathIDDir |
	nodeWithSamePathID := super targetNodeFor: aClass pathID: aPathID topology: aTopology.
	pathIDDir := nodeWithSamePathID tileInWhichCollapsed directionOfSymbol: aPathID.
	
	pathIDDir ifNil: [ ^ nodeWithSamePathID ].
	
	^ (nodeWithSamePathID neighbourAtDirection: pathIDDir) ifNil: [ ^ nodeWithSamePathID ]
	
	
	
		
	
	
	
]
