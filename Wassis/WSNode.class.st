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
		'collapseStep',
		'isCollapsed',
		'entropy',
		'tileInWhichCollapsed',
		'footPrint',
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
WSNode >> = anotherObject [

    self class = anotherObject class ifFalse: [ ^ false ].
    ^ self id = anotherObject id and: [ self position = anotherObject position ]
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

{ #category : 'deprecated' }
WSNode >> areEdgesCompatible2: edgeA with: edgeB [
    "Two edges are compatible if:
     - they are equal, OR
     - one is a real pathID (not empty, not placeholder) and the other is a placeholder"

    | placeholders emptySymbol |
    emptySymbol := WSConfig emptyEdgeSymbol.
    placeholders := { WSConfig firstPathSymbol . WSConfig secondPathSymbol }.

    edgeA = edgeB ifTrue: [ ^ true ].

    ((placeholders notIncludes: edgeA) and: [ edgeA ~= emptySymbol ])
        ifTrue: [ ^ placeholders includes: edgeB ].

    ((placeholders notIncludes: edgeB) and: [ edgeB ~= emptySymbol ])
        ifTrue: [ ^ placeholders includes: edgeA ].

    ^ false
]

{ #category : 'propagating' }
WSNode >> areEdgesCompatible: edgeA with: edgeB [
    "Two edges are compatible if:
     - they are equal, OR
	  - both are placeholders OR
     - one is a real pathID (not empty, not placeholder) and the other is a placeholder"
	
	edgeA = edgeB ifTrue: [ ^ true ].
	((WSConfig isPlaceholder: edgeA) and: [ WSConfig isPlaceholder: edgeB ]) ifTrue: [ ^ true ].

	(WSConfig isPlaceholder: edgeA) ifTrue: [ ^ (WSConfig isPathID: edgeB)].
	(WSConfig isPlaceholder: edgeB) ifTrue: [ ^ (WSConfig isPathID: edgeA)].

	^ false
]

{ #category : 'accessing' }
WSNode >> collapseStep [

	^ collapseStep
]

{ #category : 'accessing' }
WSNode >> collapseStep: anObject [

	collapseStep := anObject
]

{ #category : 'collapse' }
WSNode >> collapseTo: aTile [
    "Collapse the node to a tile, resolving placeholders if it's a path tile"

    | resolvedTile |
    resolvedTile := (aTile isPathTile and: [ self hasCollapsedNeighbours ])
        ifTrue:  [ self resolvePathTile: aTile ]
        ifFalse: [ aTile ].

    self
        possibleTiles: (Set with: resolvedTile);
        isCollapsed: true;
        tileInWhichCollapsed: resolvedTile.

    self updateShannonEntropyFromScratch.
    ^ self
]

{ #category : 'accessing' }
WSNode >> column [
	
	^ self position second
]

{ #category : 'copying' }
WSNode >> copyWithoutEdges [
	"Return a copy of self without outgoingEdge"
	
	| newNode |
	newNode := self class new.
	
	^ newNode 
		id: self id;
		collapseStep: self collapseStep;
		tileInWhichCollapsed: self tileInWhichCollapsed;
		possibleTiles: self possibleTiles copy;
		isCollapsed: self isCollapsed;
		position: self position;
		entropy: self entropy.

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
WSNode >> footPrint [

	^ footPrint
]

{ #category : 'accessing' }
WSNode >> footPrint: anObject [

	footPrint := anObject
]

{ #category : 'testing' }
WSNode >> hasCollapsedNeighbours [
	"True if at least one neighbouring node is already collapsed"
	
	^ self outgoingEdges anySatisfy: [ :eachEdge | eachEdge target isCollapsed ]
]

{ #category : 'comparing' }
WSNode >> hash [
    ^ self id hash bitXor: self position hash
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
WSNode >> isCrossingNode [ 
	
	| tile |
	tile := self tileInWhichCollapsed.
	^ tile isPathTile and: [ tile isCrossingTile ]
]

{ #category : 'testing' }
WSNode >> isEmptyNode [
	
	^ self tileInWhichCollapsed isEmptyTile 

]

{ #category : 'testing' }
WSNode >> isNotClassNode [ 
	
	^ self isClassNode not
]

{ #category : 'testing' }
WSNode >> isNotCollapsed [
	
	^ self isCollapsed not
]

{ #category : 'testing' }
WSNode >> isNotCrossingNode [

	^ self isCrossingNode not
]

{ #category : 'testing' }
WSNode >> isNotEmptyNode [

	^ self isEmptyNode not
]

{ #category : 'testing' }
WSNode >> isPathNode [ 
	
	^ self tileInWhichCollapsed isPathTile 
]

{ #category : 'propagating' }
WSNode >> isPlaceholderAssignmentConsistentFor: aTile [
    "For each collapsed neighbour, check that the placeholder on that side maps to the same real pathID consistently.
     Example: firstPath on right → #1, firstPath on bottom → #2 => INCONSISTENT"

    | assignment |
    assignment := Dictionary new. 

    self outgoingEdges do: [ :edge |
        | neighbour myEdge neighbourEdge |
        neighbour := edge target.
        neighbour isCollapsed ifTrue: [
            myEdge := (aTile edges at: edge direction) first.
            neighbourEdge := (neighbour tileInWhichCollapsed edges at: edge oppositeDirection) first.

            ((WSConfig isPlaceholder: myEdge) and: [ WSConfig isPathID: neighbourEdge ]) ifTrue: [
                    | existing |
                    existing := assignment at: myEdge ifAbsent: [ nil ].
                    existing
                        ifNil:  [ assignment at: myEdge put: neighbourEdge ]
                        ifNotNil: [ existing = neighbourEdge ifFalse: [ ^ false ] ] ] ] ].

    ^ true
]

{ #category : 'deprecated' }
WSNode >> isTileConsistent: aTile [
	"Returns true if aTile placeholders do not conflict with already resolved concrete pathIDs of all neighbors."
	
	| mapping placeholders emptySymbol |
	emptySymbol := WSConfig emptyEdgeSymbol.
	placeholders := { WSConfig firstPathSymbol . WSConfig secondPathSymbol }.
	mapping := Dictionary new.

	self outgoingEdges do: [ :eachEdge |
		| neighbor dir oppDir neighborEdges concretePIDs |
		neighbor := eachEdge target.
		dir := eachEdge direction.
		oppDir := eachEdge reverseEdge direction.
		
		"Prendi tutti i simboli che il vicino può offrire su questa faccia condivisa"
		neighborEdges := neighbor possibleTiles flatCollect: [ :t | t edges at: oppDir ].
		
		"Isola solo i pathID reali/concreti già decisi dal vicino (escludi vuoti e placeholder)"
		concretePIDs := neighborEdges select: [ :sym | 
			(placeholders includes: sym) not and: [ sym ~= emptySymbol ] ].
		
		"Se il vicino ha una situazione definita per questa strada (ha un solo pathID concreto possibile)"
		concretePIDs asSet size = 1 ifTrue: [
			| concretePID myEdgeSymbols |
			concretePID := concretePIDs anyOne.
			myEdgeSymbols := aTile edges at: dir.
			
			"Verifica se i placeholder della tessera candidata vanno in conflitto"
			myEdgeSymbols do: [ :mySym |
				(placeholders includes: mySym) ifTrue: [
					(mapping includesKey: mySym) ifTrue: [
						"Se questo placeholder era già stato mappato a un ALTRO percorso su un'altra faccia -> CONFLITTO!"
						(mapping at: mySym) = concretePID ifFalse: [ ^ false ] ].
					mapping at: mySym put: concretePID ] ] ] ].
	^ true
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
WSNode >> neighbourAtDirection: aDirection [
	"Returns the node in the specified direction"
	
	^ (self outgoingEdgeAtDirection: aDirection) target
	
	
]

{ #category : 'accessing' }
WSNode >> outgoingEdgeAtDirection: aDirection [
	"Return the outgoing edge at the desired direction"

	^ self outgoingEdges 
		detect: [ :eachEdge | eachEdge direction = aDirection ]
		ifNone: [ nil ]
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

{ #category : 'deprecated' }
WSNode >> reducePossibilitiesBasedOn2: aNode withConnectionEdge: anEdge [
	"Reduce the possible tiles and return the removed ones in a single fast pass."
	
	| anEdgeDirection anEdgeOpposite aNodeEdges fixedPaths oldTiles newTiles removedTiles firstSym secondSym |
	
	anEdgeDirection := anEdge direction.
	anEdgeOpposite := anEdge oppositeDirection.
	firstSym := WSConfig firstPathSymbol.
	secondSym := WSConfig secondPathSymbol.
	
	aNodeEdges := Set new.
	aNode possibleTiles do: [ :eachTile |
		(eachTile edges at: anEdgeDirection) do: [ :sym | aNodeEdges add: sym ] ].

	fixedPaths := OrderedCollection new: 4.
	self outgoingEdges do: [ :edge |
		edge target isCollapsed ifTrue: [
			| sym |
			sym := (edge target tileInWhichCollapsed edges at: edge oppositeDirection) first.
			(WSConfig isPlaceholder: sym) ifFalse: [ fixedPaths add: (edge direction -> sym) ] ] ].

	oldTiles := self possibleTiles.
	newTiles := OrderedCollection new: oldTiles size.
	removedTiles := OrderedCollection new: oldTiles size.
	
	oldTiles do: [ :eachTile |
		| isLocallyCompatible |
		
		isLocallyCompatible := (eachTile edges at: anEdgeOpposite) anySatisfy: [ :myEdge |
			aNodeEdges anySatisfy: [ :theirEdge | self areEdgesCompatible: myEdge with: theirEdge ] ].
		
		isLocallyCompatible 
			ifFalse: [ removedTiles add: eachTile ]
			ifTrue: [
				| isGloballyConsistent p1 p2 |
				isGloballyConsistent := true.
				p1 := nil. 
				p2 := nil.
				
				1 to: fixedPaths size do: [ :i |
					isGloballyConsistent ifTrue: [
						| assoc dir concrete tileSym |
						assoc := fixedPaths at: i.
						dir := assoc key.
						concrete := assoc value.
						
						tileSym := (eachTile edges at: dir) first.
						
						tileSym = firstSym ifTrue: [
							p1 ifNil: [ p1 := concrete ] 
							   ifNotNil: [ p1 = concrete ifFalse: [ isGloballyConsistent := false ] ] ].
						tileSym = secondSym ifTrue: [
							p2 ifNil: [ p2 := concrete ] 
							   ifNotNil: [ p2 = concrete ifFalse: [ isGloballyConsistent := false ] ] ] ] ].
							   
				isGloballyConsistent 
					ifTrue: [ newTiles add: eachTile ]
					ifFalse: [ removedTiles add: eachTile ] ] ].
	
	self possibleTiles: newTiles.
	^ removedTiles
]

{ #category : 'propagating' }
WSNode >> reducePossibilitiesBasedOn: aNode withConnectionEdge: anEdge [
	"Reduce the possible tiles and return the removed ones in a single fast pass."
	
	| direction oppositeDirection aNodeEdges oldTiles newTiles  |
	direction := anEdge direction.
	oppositeDirection := anEdge oppositeDirection.
	
	aNodeEdges := aNode possibleTiles flatCollect: [ :eachTile | eachTile edges at: direction].

	oldTiles := self possibleTiles copy.
	
    newTiles := oldTiles select: [ :eachTile |
        ((eachTile edges at: oppositeDirection) anySatisfy: [ :myEdge |
            aNodeEdges anySatisfy: [ :theirEdge |
                self areEdgesCompatible: myEdge with: theirEdge ] ])
        and: [ self isPlaceholderAssignmentConsistentFor: eachTile ] ].

	self possibleTiles: newTiles.
	
	^ oldTiles difference: newTiles
]

{ #category : 'collapse' }
WSNode >> resolvePathTile: aTile [
    "Build a specialized copy of aTile replacing firstPath/secondPath 
     with real pathIDs inherited from collapsed neighbours.
     Each placeholder is resolved independently (needed for crossing tiles)."

    | placeholderMapping |
    placeholderMapping := Dictionary new.

    self outgoingEdges do: [ :eachEdge |
        | neighbour mySymbol neighbourSymbol |
        neighbour := eachEdge target.
        neighbour isCollapsed ifTrue: [
            mySymbol := (aTile edges at: eachEdge direction) first.
            neighbourSymbol := (neighbour tileInWhichCollapsed edges at: eachEdge oppositeDirection) first.
            ((WSConfig isPlaceholder: mySymbol) and: [ WSConfig isPathID: neighbourSymbol ]) 
					ifTrue: [
                    (placeholderMapping includesKey: mySymbol)
                        ifFalse: [ placeholderMapping at: mySymbol put: neighbourSymbol ] ] ] ].

    placeholderMapping ifEmpty: [ ^ aTile ].

    ^ aTile specializedWith: placeholderMapping
]

{ #category : 'accessing' }
WSNode >> row [
	
	^ self position first
]

{ #category : 'collapse' }
WSNode >> selectInWhichTileToCollapse [
	"Return the tile in which the node should collapse (weighted choice)"

	| randomNumber |
	self possibleTiles 
        detect: [ :tile | tile isEmptyTile ] 
        ifFound: [ :emptyTile | ^ emptyTile ].
	
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

	| deltaWeight deltaWeightLog |
	deltaWeight := 0.
	deltaWeightLog := 0.

	aTilesArray do: [ :tile |
		deltaWeight := deltaWeight + tile weight.
		deltaWeightLog := deltaWeightLog + tile weightPerLogWeight 
	]. 

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
	
	sumOfW <= 0 ifTrue: [ self entropy: 0. ^ 0 ].
	
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

			sumOfW := sumOfW + tile weight.
			sumOfWLn := sumOfWLn + tile weightPerLogWeight ].

	shannonEntropy := sumOfW <= 0
        ifTrue: [ 0 ]
        ifFalse: [ sumOfW ln - (sumOfWLn / sumOfW) ].

	self sumOfWeights: sumOfW.
	self sumOfWeightsLog: sumOfWLn.
	self entropy: shannonEntropy.

	^ shannonEntropy
]
