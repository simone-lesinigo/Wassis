"
Represents the entities of a software system
"
Class {
	#name : 'WSSoftwareSystem',
	#superclass : 'WSObject',
	#instVars : [
		'classes',
		'classesPathIDs',
		'avgNumOfConnectionsPerClass',
		'allConnectionsPerClass'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'instance creation' }
WSSoftwareSystem class >> createForClass: aClass usingStrategy: aStrategy [
	"Create the necessary WFCClass objects using the selected strategy"
	
	| instance dict |
	instance := self new.
	
	dict := aStrategy createNodesFor: aClass.
	instance avgNumOfConnectionsPerClass: (aStrategy createConnectionsOn: dict).
	
	dict valuesDo: [ :eachClass | instance addClass: eachClass ].
	
	instance createPathIDsFromClasses.
	instance createAllConnectionsPerClass.
	
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
WSSoftwareSystem >> avgNumOfConnectionsPerClass [

	^ avgNumOfConnectionsPerClass
]

{ #category : 'accessing' }
WSSoftwareSystem >> avgNumOfConnectionsPerClass: anObject [

	avgNumOfConnectionsPerClass := anObject
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
   		self allConnectionsPerClass at: eachClass ifAbsentPut: [ Set new ] ].
	 	
	self classes do: [ :eachClass |
   		eachClass connectedWith do: [ :eachConnection |
      		| target |
         target := eachConnection target.
         (self allConnectionsPerClass at: eachClass) add: target.
         (self allConnectionsPerClass at: target ifAbsentPut: [ Set new ]) add: eachClass ] ]
]

{ #category : 'creation' }
WSSoftwareSystem >> createPathIDsFromClasses [
	"Create all the necessary pathIDs to connect the classes and them to the PathIDs collection"
	
	self classes do: [ :eachClass | 
		eachClass connectedWith do: [ :eachConnection |
			| target pathID |
			target := eachConnection target.	
			pathID := self pathIDFrom: (eachClass id) to: (target id).
			
			self classesPathIDs at: (eachClass  -> target) ifAbsentPut: [ pathID ].
					
	] ]
]

{ #category : 'initialization' }
WSSoftwareSystem >> initialize [ 
	super initialize.
	self classes: OrderedCollection new.
	self classesPathIDs: ClassesPathIDDictionary new.
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

{ #category : 'initialization' }
WSSoftwareSystem >> pathIDsOf: aClass [
	"Returns an OrderedCollection of PathIDs linked to a class"
	
	^ self classesPathIDs pathIDsFor: aClass withConnections: (self allConnectionsOf: aClass)
]
