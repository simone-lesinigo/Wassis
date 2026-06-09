"
Represents the entities of a software system
"
Class {
	#name : 'WSSoftwareSystem',
	#superclass : 'WSObject',
	#instVars : [
		'classes',
		'classesPathIDs',
		'allConnectionsPerClass',
		'pathIDToClasses'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'instance creation' }
WSSoftwareSystem class >> usingStrategy: aStrategy [
	"Create the necessary WSClass objects using the selected strategy"
	
	| instance dict |
	instance := self new.
	
	dict := aStrategy createNodes.

	aStrategy createConnectionsOn: dict.
	
	dict valuesDo: [ :eachClass | instance addClass: eachClass ].

	instance 
		createPathIDsFromClassesAllowinMerge;
		createAllConnectionsPerClass;
		createClassesPerPathID.

	^ instance
	
	
]

{ #category : 'adding' }
WSSoftwareSystem >> addClass: aClass [
	
	self classes add: aClass
]

{ #category : 'adding' }
WSSoftwareSystem >> addClasses: aClassArray [

	self classes addAll: aClassArray 
]

{ #category : 'accessing' }
WSSoftwareSystem >> allClassesConnectedByPathID: aPathID [
	"Return a set with all the classes that share the same pathID"
	
	^ pathIDToClasses at: aPathID 
]

{ #category : 'accessing' }
WSSoftwareSystem >> allConnectionsOf: aClass [
	
	^ self allConnectionsPerClass at: aClass 
]

{ #category : 'accessing' }
WSSoftwareSystem >> allConnectionsPerClass [

	^ allConnectionsPerClass
]

{ #category : 'accessing' }
WSSoftwareSystem >> allConnectionsPerClass: anObject [

	allConnectionsPerClass := anObject
]

{ #category : 'accessing' }
WSSoftwareSystem >> allPathIDs [
	
	^ self classesPathIDs asSet asOrderedCollection 
]

{ #category : 'accessing' }
WSSoftwareSystem >> classes [

	^ classes
]

{ #category : 'accessing' }
WSSoftwareSystem >> classes: anObject [

	classes := anObject
]

{ #category : 'accessing' }
WSSoftwareSystem >> classesPathIDs [

	^ classesPathIDs
]

{ #category : 'accessing' }
WSSoftwareSystem >> classesPathIDs: anObject [

	classesPathIDs := anObject
]

{ #category : 'creation' }
WSSoftwareSystem >> createAllConnectionsPerClass [
	"Create a dictionary. The key is a class, the value is a Set with all the classes thata are connected to that class (undirected)"

	self allConnectionsPerClass: Dictionary new.
	 	
	self classes do: [ :eachClass |
   		eachClass outgoingConnections do: [ :eachConnection |
      		| target |
         target := eachConnection target.
         (self allConnectionsPerClass at: eachClass ifAbsentPut: [ Set new ]) add: target.
         (self allConnectionsPerClass at: target ifAbsentPut: [ Set new ]) add: eachClass ] ]
]

{ #category : 'creation' }
WSSoftwareSystem >> createClassesPerPathID [
    "For each pathID, provides the classes that share that ID"
    
    self classesPathIDs keysAndValuesDo: [ :compositeKey :pathID |
        | classSet source destination |
     
        source := compositeKey first.
        destination := compositeKey second.
        
        classSet := self pathIDToClasses at: pathID ifAbsentPut: [ Set new ].
        classSet add: source; add: destination ].
]

{ #category : 'deprecated' }
WSSoftwareSystem >> createPathIDsFromClasses [
	"Create all the necessary pathIDs to connect the classes and them to the PathIDs collection"
	
	self classes do: [ :eachClass | 
		eachClass outgoingConnections do: [ :eachConnection |
			| target pathID |
			target := eachConnection target.	
			pathID := self pathIDFrom: (eachClass id) to: (target id).
			
			self classesPathIDs at: (eachClass  -> target) ifAbsentPut: [ pathID ].
					
	] ]
]

{ #category : 'creation' }
WSSoftwareSystem >> createPathIDsFromClassesAllowinMerge [
    "Classes that are connected to the same class share the same pathID"
    
    | destinationTypeToSources |
    destinationTypeToSources := Dictionary new.
    
    self classes do: [ :eachClass |
        eachClass outgoingConnections do: [ :eachConnection |
            eachConnection relations do: [ :eachRelation |
                | key |
                key := eachConnection target -> eachRelation.
                (destinationTypeToSources at: key ifAbsentPut: [ OrderedCollection new ]) add: eachClass ] ] ].

    destinationTypeToSources keysAndValuesDo: [ :destAndType :sources |
        | destination relationType allIDs pathID |
        destination := destAndType key.
        relationType := destAndType value.
        allIDs := ((sources collect: [ :s | s id ]) copyWith: destination id) asSortedCollection.
        pathID := (allIDs inject: '' into: [ :acc :id | acc , id printString ]) , '-' , relationType name.
        
        sources do: [ :source |
            self classesPathIDs 
                at: source and: destination and: relationType 
                put: pathID ] ]
]

{ #category : 'creation' }
WSSoftwareSystem >> createPathIDsFromClassesAllowinMerge2 [
    "Classes that are connected to the same class share the same pathID"
    
        | destinationToSources |
    destinationToSources := Dictionary new.
    
    self classes do: [ :eachClass |
        eachClass outgoingConnections do: [ :eachConnection |
            | target |
            target := eachConnection target.
            (destinationToSources at: target ifAbsentPut: [ OrderedCollection new ])
                add: eachClass ] ].
 
    destinationToSources keysAndValuesDo: [ :destination :sources |
        | allIDs pathID |
        allIDs := ((sources collect: [ :s | s id ]) copyWith: destination id) asSortedCollection.

        pathID := allIDs inject: '' into: [ :acc :id | acc , id printString ].
        
        sources do: [ :source |
            self classesPathIDs at: (source -> destination) put: pathID ] ]
]

{ #category : 'initialization' }
WSSoftwareSystem >> initialize [ 
	super initialize.
	self classes: OrderedCollection new.
	self classesPathIDs: ClassesPathIDDictionary new.
	self pathIDToClasses: Dictionary new.
]

{ #category : 'creation' }
WSSoftwareSystem >> pathIDFrom: id1 to: id2 [
	"Create a single path ID"
	^ (id1 < id2)
		ifTrue: [ ('' join: { id1 asString . id2 asString }) asSymbol ] 
		ifFalse: [ ('' join: { id2 asString . id1 asString }) asSymbol ] 
]

{ #category : 'accessing' }
WSSoftwareSystem >> pathIDOf: class1 and: class2 [
	"Returns the pathID between two classes"
	
	^ self classesPathIDs at: (class1 -> class2)
]

{ #category : 'accessing' }
WSSoftwareSystem >> pathIDToClasses [

	^ pathIDToClasses
]

{ #category : 'accessing' }
WSSoftwareSystem >> pathIDToClasses: anObject [

	pathIDToClasses := anObject
]

{ #category : 'initialization' }
WSSoftwareSystem >> pathIDsOf: aClass [
	"Returns an OrderedCollection of PathIDs linked to a class"
	
	^ self classesPathIDs pathIDsFor: aClass withConnections: (self allConnectionsOf: aClass)
]

{ #category : 'as yet unclassified' }
WSSoftwareSystem >> pathIDsOf: class1 and: class2 [
    "Returns all pathIDs between two classes, one per relation type"

    ^ self classesPathIDs keys
        select: [ :key | (key first = class1 and: [ key second = class2 ])
                      or: [ key first = class2 and: [ key second = class1  ] ] ]
        thenCollect: [ :key | self classesPathIDs at: key ]
]
