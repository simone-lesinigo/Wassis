"
It doesn't assign a target. Paths will be generated at random
"
Class {
	#name : 'WSNonePathTargetStrategy',
	#superclass : 'WSPathTargetStrategy',
	#category : 'Wassis-Path Target',
	#package : 'Wassis',
	#tag : 'Path Target'
}

{ #category : 'finding' }
WSNonePathTargetStrategy >> findTargetNodeFor: aClass pathID: aPathID node: aNode topology: aTopology [
	"This method returns nil on purpose so a target is not assigned"
	
	^ nil
]
