"
Strategy to collect a class with all of its subclasses
"
Class {
	#name : 'WSSubclassesCollector',
	#superclass : 'WSHierarchyCollector',
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'creation' }
WSSubclassesCollector >> createNodes [
	"Create a Dictionary with all the super and subclasses of aClass"
	
	| dict id | 
	dict := Dictionary new.
	id := 1.
	
	originClass withAllSubclassesDo: 
		[ :eachClass | 
			dict at: eachClass put: (WSClass new id: id; name: eachClass name).
			id := id + 1 ].
	
	^ dict
]
