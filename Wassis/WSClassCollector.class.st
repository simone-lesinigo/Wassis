"
Abstract strategy to create the correct WFClass with the desired connections
"
Class {
	#name : 'WSClassCollector',
	#superclass : 'WSObject',
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'creation' }
WSClassCollector >> createConnectionsOn: aDictionary [

	^ self subclassResponsibility 
]

{ #category : 'creation' }
WSClassCollector >> createNodesFor: aClass [
	
	^ self subclassResponsibility 
]
