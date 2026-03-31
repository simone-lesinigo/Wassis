"
Strategy to collect a class with all of its subclasses
"
Class {
	#name : 'WSSubclassesCollector',
	#superclass : 'WSClassCollector',
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'creation' }
WSSubclassesCollector >> createConnectionsOn: aDictionary [
	
	aDictionary keysAndValuesDo: [ :aKey : aValue | 
		aDictionary at: (aKey superclass) ifPresent: [ :superNode |
			aValue addRelation: (WSRelationType inheritance) withClass: superNode.
			self addOneConnection
		]
	].

	^ self totalNumberOfConnections / aDictionary size
]

{ #category : 'creation' }
WSSubclassesCollector >> createNodesFor: aClass [
	"Create a Dictionary with all the super and subclasses of aClass"
	
	| dict id | 
	dict := Dictionary new.
	id := 1.
	
	aClass withAllSubclassesDo: 
		[ :eachClass | 
			dict at: eachClass put: (WSClass new id: id; name: eachClass name).
			id := id + 1 ].
	
	^ dict
]
