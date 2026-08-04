"
Contains the copy of a graph at a certain moment
"
Class {
	#name : 'WSCheckpoint',
	#superclass : 'WSObject',
	#instVars : [
		'graphSnapshot',
		'timestamp',
		'collapseEvent',
		'historySize'
	],
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'instance creation' }
WSCheckpoint class >> fromCollapseEvent: aWSCollapseEvent withHistorySize: aSize withGraph: aGraph [
	
	^ self new
		graphSnapshot: aGraph createSnapshot;
		historySize: aSize;
		collapseEvent: aWSCollapseEvent;
		timestamp: DateAndTime now
]

{ #category : 'accessing' }
WSCheckpoint >> collapseEvent [

	^ collapseEvent
]

{ #category : 'accessing' }
WSCheckpoint >> collapseEvent: anObject [

	collapseEvent := anObject
]

{ #category : 'accessing' }
WSCheckpoint >> graphSnapshot [

	^ graphSnapshot
]

{ #category : 'accessing' }
WSCheckpoint >> graphSnapshot: anObject [

	graphSnapshot := anObject
]

{ #category : 'accessing' }
WSCheckpoint >> historySize [

	^ historySize
]

{ #category : 'accessing' }
WSCheckpoint >> historySize: anObject [

	historySize := anObject
]

{ #category : 'accessing' }
WSCheckpoint >> timestamp [

	^ timestamp
]

{ #category : 'accessing' }
WSCheckpoint >> timestamp: anObject [

	timestamp := anObject
]
