"
Strategy to collect a class with all of its super and sub classes
"
Class {
	#name : 'WSFullHierarchyCollector',
	#superclass : 'WSHierarchyCollector',
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'creation' }
WSFullHierarchyCollector >> createNodes [
	"Create a Dictionary with all the super and subclasses of aClass"
	
	| dict id | 
	dict := Dictionary new.
	id := 1.
	
	originClass withAllSuperAndSubclassesDo: 
		[ :eachClass | 
			dict at: eachClass put: (WSClass new id: id; name: eachClass name).
			id := id + 1 ] .
	
	^ dict
]
