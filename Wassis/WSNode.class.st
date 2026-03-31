"
Represents a node of the graph. It will collapse into a tile
"
Class {
	#name : 'WSNode',
	#superclass : 'Object',
	#instVars : [
		'id',
		'position',
		'outgoingEdges',
		'possibleTiles',
		'isCollapsed',
		'entropy',
		'tileInWhichCollapsed',
		'sumOfWeights',
		'sumOfWeightsLog'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'comparing' }
WSNode >> < aNode [
	^ self entropy < aNode entropy

	
]

{ #category : 'comparing' }
WSNode >> <= aNode [
	^ self entropy <=  aNode entropy
]

{ #category : 'comparing' }
WSNode >> > aNode [
	^ self entropy > aNode entropy
	
]

{ #category : 'comparing' }
WSNode >> >= aNode [
	^ self entropy >=  aNode entropy
]

{ #category : 'adding' }
WSNode >> addEdge: anEdge [

	self outgoingEdges add: anEdge
]

{ #category : 'collapse' }
WSNode >> collapseTo: aTile [
	"Collapse the node to a tile"

	self
		possibleTiles: (Set with: aTile);
		isCollapsed: true;
		tileInWhichCollapsed: aTile.
	
	self updateShannonEntropyFromScratch 
]

{ #category : 'collapse' }
WSNode >> collapseToClassTile: aTile [

	self 
		isCollapsed: true;
		possibleTiles: (Set with: aTile);
		tileInWhichCollapsed: aTile.
		
	self updateShannonEntropyFromScratch.
	
	^ self
	
	
	
]

{ #category : 'accessing' }
WSNode >> entropy [

	^ entropy
]

{ #category : 'accessing' }
WSNode >> entropy: anObject [

	entropy := anObject
]

{ #category : 'accessing' }
WSNode >> id [

	^ id
]

{ #category : 'accessing' }
WSNode >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
WSNode >> initialize [
	super initialize.
	self 
		outgoingEdges: OrderedCollection new
	
]

{ #category : 'testing' }
WSNode >> isClassNode [ 
	
	^ self tileInWhichCollapsed isClassTile 
]

{ #category : 'accessing' }
WSNode >> isCollapsed [

	^ isCollapsed
]

{ #category : 'accessing' }
WSNode >> isCollapsed: anObject [

	isCollapsed := anObject
]

{ #category : 'testing' }
WSNode >> isNotCollapsed [
	
	^ self isCollapsed not
]

{ #category : 'testing' }
WSNode >> isPathNode [ 
	
	^ self tileInWhichCollapsed isPathTile 
]

{ #category : 'updating' }
WSNode >> keepTilesWithIDin: anArray [
	"Keep all the tiles in a WFCNode where the ID is in anArray, reject the other"

	| filteredPossibleTiles |
	
	filteredPossibleTiles := 
		self possibleTiles select: [ :eachTile | anArray includes: eachTile id ].
		
	self possibleTiles: filteredPossibleTiles.
	self updateShannonEntropyFromScratch 
]

{ #category : 'accessing' }
WSNode >> outgoingEdges [

	^ outgoingEdges
]

{ #category : 'accessing' }
WSNode >> outgoingEdges: anObject [

	outgoingEdges := anObject
]

{ #category : 'accessing' }
WSNode >> position [

	^ position
]

{ #category : 'accessing' }
WSNode >> position: anObject [

	position := anObject
]

{ #category : 'accessing' }
WSNode >> possibleTiles [

	^ possibleTiles
]

{ #category : 'accessing' }
WSNode >> possibleTiles: anObject [

	possibleTiles := anObject
]

{ #category : 'updating' }
WSNode >> reducePossibilitiesBasedOn: aNode withConnectionEdge: anEdge [
	"Reduce the possible tiles of self based on the constraint of aNode. Returns all the removed tiles"
	
	| direction oppositeDirection aNodeEdges oldTiles newTiles  |
	direction := anEdge direction.
	oppositeDirection := anEdge reverseEdge direction.
	
	aNodeEdges := aNode possibleTiles flatCollect: [ :eachTile | eachTile edges at: direction].

	oldTiles := self possibleTiles copy.
	
	newTiles := oldTiles select: 
		[ :eachTile | (eachTile edges at: oppositeDirection) anySatisfy: 
			[ :edgeNumber | aNodeEdges includes: edgeNumber ] ].
	
	self possibleTiles: newTiles.
	
	^ oldTiles difference: newTiles
	
]

{ #category : 'collapse' }
WSNode >> selectInWhichTileToCollapse [
	"Return the tile in which the node should collapse (weighted choice)"

	| randomNumber |
	randomNumber := self sumOfWeights atRandom.

	^ self possibleTiles detect: [ :tile |
			  randomNumber := randomNumber - tile weight.
			  randomNumber <= 0 ]
]

{ #category : 'accessing' }
WSNode >> sumOfWeights [

	^ sumOfWeights
]

{ #category : 'accessing' }
WSNode >> sumOfWeights: anObject [

	sumOfWeights := anObject
]

{ #category : 'accessing' }
WSNode >> sumOfWeightsLog [

	^ sumOfWeightsLog
]

{ #category : 'accessing' }
WSNode >> sumOfWeightsLog: anObject [

	sumOfWeightsLog := anObject
]

{ #category : 'accessing' }
WSNode >> tileInWhichCollapsed [

	^ tileInWhichCollapsed
]

{ #category : 'accessing' }
WSNode >> tileInWhichCollapsed: anObject [

	tileInWhichCollapsed := anObject
]

{ #category : 'updating' }
WSNode >> updateEntropyRemovingTiles: aTilesArray [
	"The node updates its own entropy by removing the tiles in aTilesArray"
	<toDo> "Ottimizzazione: salvare in ogni tile all'inizio (tile weight * (tile weight ln) in modo da non doverla ricalcolare ogni volta"
	| deltaWeight deltaWeightLog |
	deltaWeight := 0.
	deltaWeightLog := 0.

	aTilesArray do: [ :tile |
		deltaWeight := deltaWeight + tile weight.
		deltaWeightLog := deltaWeightLog + (tile weight * (tile weight ln)) ]. 

	self sumOfWeights: (self sumOfWeights - deltaWeight).
	self sumOfWeightsLog: (self sumOfWeightsLog - deltaWeightLog).
	self updateShannonEntropy .
]

{ #category : 'updating' }
WSNode >> updateShannonEntropy [
	"Return the Shannon Entropy of a node by accessing as its two attributes"

	| shannonEntropy sumOfW sumOfWLn |
	sumOfW := self sumOfWeights.
	sumOfWLn := self sumOfWeightsLog.

	shannonEntropy := sumOfW ln - (sumOfWLn / sumOfW).
	self entropy: shannonEntropy.

	^ shannonEntropy
]

{ #category : 'updating' }
WSNode >> updateShannonEntropyFromScratch [
	"Return the Shannon Entropy of a node not accessing to its attributes but by calculating it from scratch. Then it updates all 3 attributes"

	| shannonEntropy sumOfW sumOfWLn |
	sumOfW := 0.
	sumOfWLn := 0.

	self possibleTiles do: [ :tile |
			| tileWeight |
			tileWeight := tile weight.

			sumOfW := sumOfW + tileWeight.
			sumOfWLn := sumOfWLn + (tileWeight * tileWeight ln) ].

	shannonEntropy := sumOfW ln - (sumOfWLn / sumOfW).

	self sumOfWeights: sumOfW.
	self sumOfWeightsLog: sumOfWLn.
	self entropy: shannonEntropy.

	^ shannonEntropy
]
