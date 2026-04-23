"
Strategy to collect a class with all of its subclasses
"
Class {
	#name : 'WSSuperclassesCollector',
	#superclass : 'WSClassCollector',
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'creation' }
WSSuperclassesCollector >> createConnectionsOn: aDictionary [
	
	aDictionary keysAndValuesDo: [ :aKey : aValue | 
		aDictionary at: (aKey superclass) ifPresent: [ :superNode |
			aValue addRelation: (WSRelationType inheritance) withClass: superNode.
		]
	]
]

{ #category : 'creation' }
WSSuperclassesCollector >> createNodesFor: aClass [
	"Create a Dictionary with all the super and subclasses of aClass"
	
	| dict id | 
	dict := Dictionary new.
	id := 1.
	
	aClass withAllSuperclassesDo: 
		[ :eachClass | 
			dict at: eachClass put: (WSClass new id: id; name: eachClass name).
			id := id + 1 ].
	
	^ dict
]
