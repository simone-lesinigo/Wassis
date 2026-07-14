"
Defines the strategy for selecting the target of each path of a class
"
Class {
	#name : 'WSPathTargetStrategy',
	#superclass : 'WSObject',
	#category : 'Wassis-Path Target',
	#package : 'Wassis',
	#tag : 'Path Target'
}

{ #category : 'finding' }
WSPathTargetStrategy >> findTargetNodeFor: aClass pathID: aPathID node: aNode topology: aTopology [
	
	^ self subclassResponsibility 
]
