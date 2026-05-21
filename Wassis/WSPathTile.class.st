"
Represents a path tile
"
Class {
	#name : 'WSPathTile',
	#superclass : 'WSTile',
	#instVars : [
		'pathIDs'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'instance creation' }
WSPathTile class >> withID: anID withWeight: aWeight withEdges: edges withPathIDs: pathIDs [
	
	^ self new
		id: anID;
      weight: aWeight;
      edges: edges;
		pathIDs: pathIDs
]

{ #category : 'visualization' }
WSPathTile >> accept: aVisitor [ 

	^ aVisitor visitPathTile: self
]

{ #category : 'control' }
WSPathTile >> addItemToMenu: aMenu onNode: aNode usingSolver: aSolver [
	"Add to the contextual menu (right click) the necessary items"

	| currentPathID |
	currentPathID := aNode tileInWhichCollapsed pathID.

	aMenu 
		add: 'Inspect Path' 
		target: [ (aSolver graph paths at: currentPathID) inspect] 
		selector: #value.
		
   aMenu 
		add: 'Optimize Path'
   		target: [ self optimizePath: currentPathID withSolver: aSolver ]
      selector: #value.
]

{ #category : 'visualization' }
WSPathTile >> buildPopup [ 
	
	^ RSPopup new text: [ 'Path Tile: ', self pathID ]
]

{ #category : 'testing' }
WSPathTile >> isCrossingTile [

	^ self pathIDs size > 1
]

{ #category : 'testing' }
WSPathTile >> isNotCrossingTile [

	^ self isCrossingTile not
]

{ #category : 'testing' }
WSPathTile >> isPathTile [ 
	
	^ true
]

{ #category : 'control' }
WSPathTile >> optimizePath: aPathID withSolver: aSolver [
	"Create the dialog to ask the user if he wants to allow exits modification or not"

    | touchedNodes |
        
    touchedNodes := aSolver graph optimizePaths: { aPathID }.
    "aSolver createVisualization."
    aSolver updateVisualizationFor: touchedNodes.
]

{ #category : 'accessing' }
WSPathTile >> pathID [

	^ pathIDs first 
]

{ #category : 'accessing' }
WSPathTile >> pathIDs [

	^ pathIDs
]

{ #category : 'accessing' }
WSPathTile >> pathIDs: anObject [

	pathIDs := anObject
]

{ #category : 'accessing' }
WSPathTile >> secondaryPathID [

	self isCrossingTile ifTrue: [ ^ self pathIDs second ]
]
