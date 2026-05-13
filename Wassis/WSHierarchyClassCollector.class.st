"
Strategy to collect a class with all of its super and sub classes
"
Class {
	#name : 'WSHierarchyClassCollector',
	#superclass : 'WSClassCollector',
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'creation' }
WSHierarchyClassCollector >> createConnectionsOn: aDictionary [
	
	aDictionary keysAndValuesDo: [ :aKey : aValue | 
		aDictionary at: (aKey superclass) ifPresent: [ :superNode |
			aValue addRelation: (WSRelationType inheritance) withClass: superNode.
		]
	]
]

{ #category : 'creation' }
WSHierarchyClassCollector >> createNodesFor: aClass [
	"Create a Dictionary with all the super and subclasses of aClass"
	
	| dict id | 
	dict := Dictionary new.
	id := 1.
	
	aClass withAllSuperAndSubclassesDo: 
		[ :eachClass | 
			dict at: eachClass put: (WSClass new id: id; name: eachClass name).
			id := id + 1 ] .
	
	^ dict
]
