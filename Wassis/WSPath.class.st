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
		'class1',
		'class2'
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
WSPath >> addNode: aNode [

	self nodes add: aNode
]

{ #category : 'converting' }
WSPath >> asOrderedCollection [
	
	self nodes: self nodes asOrderedCollection 
]

{ #category : 'accessing' }
WSPath >> class1 [

	^ class1
]

{ #category : 'accessing' }
WSPath >> class1: anObject [

	class1 := anObject
]

{ #category : 'accessing' }
WSPath >> class2 [

	^ class2
]

{ #category : 'accessing' }
WSPath >> class2: anObject [

	class2 := anObject
]

{ #category : 'private' }
WSPath >> computeLength [

	self length: self nodes size
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
