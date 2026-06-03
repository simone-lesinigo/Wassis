"
Strategy to collect the hierarchy of a class
"
Class {
	#name : 'WSHierarchyCollector',
	#superclass : 'WSClassCollector',
	#instVars : [
		'originClass'
	],
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'instance creation' }
WSHierarchyCollector class >> withOriginClass: aClass [
	
	^ self new originClass: aClass
]

{ #category : 'creation' }
WSHierarchyCollector >> createConnectionsOn: aDictionary [
	
	aDictionary keysAndValuesDo: [ :aKey : aValue | 
		aDictionary at: (aKey superclass) ifPresent: [ :superNode |
			aValue addRelation: (WSRelationType inheritance) withClass: superNode.
		]
	]
]

{ #category : 'creation' }
WSHierarchyCollector >> createNodes [ 
	
	^ self subclassResponsibility
]

{ #category : 'accessing' }
WSHierarchyCollector >> originClass [

	^ originClass
]

{ #category : 'accessing' }
WSHierarchyCollector >> originClass: anObject [

	originClass := anObject
]
