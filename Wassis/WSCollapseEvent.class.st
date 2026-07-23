"
Object created when a nodes is collapsed. It stores the information that are necesarry for the backtracking classes to: 
- decide if the snapshot needs to be saved or not 
- modify the weight so that we are sure that a different decision is made
"
Class {
	#name : 'WSCollapseEvent',
	#superclass : 'WSObject',
	#instVars : [
		'node',
		'possibleTiles',
		'chosenTile'
	],
	#category : 'Wassis-Backtracking',
	#package : 'Wassis',
	#tag : 'Backtracking'
}

{ #category : 'instance creation' }
WSCollapseEvent class >> node: aNode possibleTiles: possibleTiles chosenTile: aTile [
	
	^ self new
		node: aNode;
		possibleTiles: possibleTiles;
		chosenTile: aTile
		
]

{ #category : 'accessing' }
WSCollapseEvent >> chosenTile [

	^ chosenTile
]

{ #category : 'accessing' }
WSCollapseEvent >> chosenTile: anObject [

	chosenTile := anObject
]

{ #category : 'accessing' }
WSCollapseEvent >> node [

	^ node
]

{ #category : 'accessing' }
WSCollapseEvent >> node: anObject [

	node := anObject
]

{ #category : 'accessing' }
WSCollapseEvent >> possibleTiles [

	^ possibleTiles
]

{ #category : 'accessing' }
WSCollapseEvent >> possibleTiles: anObject [

	possibleTiles := anObject
]
