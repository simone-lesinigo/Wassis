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
   		target: [ self optimizePathWithUserConfirmation: currentPathID withSolver: aSolver ]
      selector: #value.
]

{ #category : 'visualization' }
WSPathTile >> buildPopup [ 
	
	^ RSPopup new text: [ 'Path Tile: ', self pathID ]
]

{ #category : 'testing' }
WSPathTile >> isPathTile [ 
	
	^ true
]

{ #category : 'control' }
WSPathTile >> optimizePathWithUserConfirmation: aPathID withSolver: aSolver [
	"Create the dialog to ask the user if he wants to allow exits modification or not"

    | allowExits touchedNodes |

    allowExits := UIManager default 
        confirm: 'Do you want to allow exit modification?' 
        label: 'Question'.
        
    touchedNodes := 
		aSolver graph 
        optimizePathsWithPathIDs: { aPathID } 
        allowExitsModification: allowExits.
    
    aSolver updateVisualizationFor: touchedNodes.
]

{ #category : 'accessing' }
WSPathTile >> pathID [

	^ pathID
]

{ #category : 'accessing' }
WSPathTile >> pathID: anObject [

	pathID := anObject
]
