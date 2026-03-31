"
Abstract strategy to create the correct WFClass with the desired connections
"
Class {
	#name : 'WSClassCollector',
	#superclass : 'WSObject',
	#instVars : [
		'totalNumberOfConnections'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'adding' }
WSClassCollector >> addOneConnection [

	self totalNumberOfConnections: self totalNumberOfConnections + 1
]

{ #category : 'creation' }
WSClassCollector >> createConnectionsOn: aDictionary [

	^ self subclassResponsibility 
]

{ #category : 'creation' }
WSClassCollector >> createNodesFor: aClass [
	
	^ self subclassResponsibility 
]

{ #category : 'initialization' }
WSClassCollector >> initialize [ 
	
	super initialize.
	self totalNumberOfConnections: 0 
]

{ #category : 'accessing' }
WSClassCollector >> totalNumberOfConnections [

	^ totalNumberOfConnections
]

{ #category : 'accessing' }
WSClassCollector >> totalNumberOfConnections: anObject [

	totalNumberOfConnections := anObject
]
