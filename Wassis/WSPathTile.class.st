"
Represents a path tile
"
Class {
	#name : 'WSPathTile',
	#superclass : 'WSTile',
	#instVars : [
		'pathID'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'instance creation' }
WSPathTile class >> withID: anID withWeight: aWeight withEdges: edges withPathID: aPathID [
	
	^ self new
		id: anID;
      weight: aWeight;
      edges: edges;
		pathID: aPathID
]

{ #category : 'visualization' }
WSPathTile >> accept: aVisitor [ 

	^ aVisitor visitPathTile: self
]

{ #category : 'control' }
WSPathTile >> buildMenu: aMenu withGraph: aGraph onNode: aNode [

	aMenu 
		add: 'Inspect Path' 
		target: (aGraph paths at: aNode tileInWhichCollapsed pathID) 
		selector: #inspect.
		
	aMenu 
		add: 'Optimize Path' 
		target: (aGraph paths at: aNode tileInWhichCollapsed pathID) 
		selector: #inspect.
]

{ #category : 'visualization' }
WSPathTile >> buildPopup [ 
	
	^ RSPopup new text: [ 'Path Tile: ', self pathID ]
]

{ #category : 'testing' }
WSPathTile >> isPathTile [ 
	
	^ true
]

{ #category : 'accessing' }
WSPathTile >> pathID [

	^ pathID
]

{ #category : 'accessing' }
WSPathTile >> pathID: anObject [

	pathID := anObject
]
