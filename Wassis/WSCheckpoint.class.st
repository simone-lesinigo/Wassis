"
Contains the copy of a graph at a certain moment
"
Class {
	#name : 'WSCheckpoint',
	#superclass : 'WSObject',
	#instVars : [
		'graphCopy',
		'timestamp',
		'try',
		'collapsedNode'
	],
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'accessing' }
WSCheckpoint >> collapsedNode [

	^ collapsedNode
]

{ #category : 'accessing' }
WSCheckpoint >> collapsedNode: anObject [

	collapsedNode := anObject
]

{ #category : 'accessing' }
WSCheckpoint >> graphCopy [

	^ graphCopy
]

{ #category : 'accessing' }
WSCheckpoint >> graphCopy: anObject [

	graphCopy := anObject
]

{ #category : 'accessing' }
WSCheckpoint >> timestamp [

	^ timestamp
]

{ #category : 'accessing' }
WSCheckpoint >> timestamp: anObject [

	timestamp := anObject
]

{ #category : 'accessing' }
WSCheckpoint >> try [

	^ try
]

{ #category : 'accessing' }
WSCheckpoint >> try: anObject [

	try := anObject
]
