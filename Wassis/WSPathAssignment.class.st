"
Data holder class to store the necessary information to assign the correct path to a node
"
Class {
	#name : 'WSPathAssignment',
	#superclass : 'WSObject',
	#instVars : [
		'pathID',
		'directionCosts',
		'targetDir',
		'alignmentDir'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'instance creation' }
WSPathAssignment class >> withPathID: aPathID withDirectionCosts: aDirectionCosts [ 
	
	^ self new
		pathID: aPathID;
		directionCosts: aDirectionCosts;
		targetDir: aDirectionCosts first;
		alignmentDir: aDirectionCosts second
]

{ #category : 'accessing' }
WSPathAssignment >> alignmentDir [

	^ alignmentDir
]

{ #category : 'accessing' }
WSPathAssignment >> alignmentDir: anObject [

	alignmentDir := anObject
]

{ #category : 'modifying' }
WSPathAssignment >> degrade [
	
	| currentIndex |
	currentIndex := self directionCosts indexOf: self targetDir.
	self targetDir: (self directionCosts at: currentIndex + 1).
	self alignmentDir: (self directionCosts first).
]

{ #category : 'accessing' }
WSPathAssignment >> directionCosts [

	^ directionCosts
]

{ #category : 'accessing' }
WSPathAssignment >> directionCosts: anObject [

	directionCosts := anObject
]

{ #category : 'accessing' }
WSPathAssignment >> pathID [

	^ pathID
]

{ #category : 'accessing' }
WSPathAssignment >> pathID: anObject [

	pathID := anObject
]

{ #category : 'accessing' }
WSPathAssignment >> targetDir [

	^ targetDir
]

{ #category : 'accessing' }
WSPathAssignment >> targetDir: anObject [

	targetDir := anObject
]
