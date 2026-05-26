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

{ #category : 'comparing' }
WSPathTile >> = anObject [

    self class = anObject class ifFalse: [ ^ false ].

    ^ self id = anObject id
        and: [ self pathIDs = anObject pathIDs
        and: [ self edges = anObject edges ] ]
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

{ #category : 'comparing' }
WSPathTile >> hash [

    ^ self id hash bitXor: self pathIDs hash
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

{ #category : 'testing' }
WSPathTile >> isPlaceholderTile [
	"Method that check if a tile is still a placeholder"
	
	 ^ self edges anySatisfy: [ :eachEdge | WSConfig isPlaceholder: eachEdge first ]
	
]

{ #category : 'testing' }
WSPathTile >> isResolvedTile [
	"Method that check if a tile is not a placeholder"

	^ self isPlaceholderTile not
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

{ #category : 'as yet unclassified' }
WSPathTile >> specializedWith: aPlaceholderMapping [
    "Return a new tile with placeholders replaced by real pathIDs.
     aPlaceholderMapping: 'firstPath' -> #17, 'secondPath' -> #23, etc."

    | newEdges newPathIDs |
    newEdges := Dictionary new.
    self edges keysAndValuesDo: [ :direction :symbols |
        newEdges 
            at: direction 
            put: (symbols collect: [ :sym | aPlaceholderMapping at: sym ifAbsent: [ sym ] ]) ].

    newPathIDs := self pathIDs collect: [ :pid | aPlaceholderMapping at: pid ifAbsent: [ pid ] ].

    ^ self class
        withID: self id
        withWeight: self weight
        withEdges: newEdges
        withPathIDs: newPathIDs
]
