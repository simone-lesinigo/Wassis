"
Superclass of different strategies for placing the classes on the graph
"
Class {
	#name : 'WSLayoutStrategy',
	#superclass : 'WSObject',
	#classInstVars : [
		'swSystemHash',
		'cachedInstance',
		'cachedDimension',
		'computationTime'
	],
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'accessing' }
WSLayoutStrategy class >> cachedDimension [

	^ cachedDimension
]

{ #category : 'accessing' }
WSLayoutStrategy class >> cachedDimension: anObject [

	cachedDimension := anObject
]

{ #category : 'accessing' }
WSLayoutStrategy class >> cachedInstance [

	^ cachedInstance
]

{ #category : 'accessing' }
WSLayoutStrategy class >> cachedInstance: anObject [

	cachedInstance := anObject
]

{ #category : 'accessing' }
WSLayoutStrategy class >> computationTime [

	^ computationTime
]

{ #category : 'accessing' }
WSLayoutStrategy class >> computationTime: anObject [

	computationTime := anObject
]

{ #category : 'instance creation' }
WSLayoutStrategy class >> computeForSystem: swSystem withDimension: aDimension [
	
	^ self subclassResponsibility 
]

{ #category : 'initialization' }
WSLayoutStrategy class >> resetCache [
	
	self swSystemHash: nil.
	self cachedInstance: nil.
	self cachedDimension: nil
	
]

{ #category : 'accessing' }
WSLayoutStrategy class >> swSystemHash [

	^ swSystemHash
]

{ #category : 'accessing' }
WSLayoutStrategy class >> swSystemHash: anObject [

	swSystemHash := anObject
]
