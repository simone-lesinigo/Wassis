"
Superclass of different strategies for placing the classes on the graph
"
Class {
	#name : 'WSLayoutStrategy',
	#superclass : 'WSObject',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'accessing' }
WSLayoutStrategy class >> computationTime [ 

	^ self subclassResponsibility 
]

{ #category : 'instance creation' }
WSLayoutStrategy class >> computeForSystem: swSystem withDimension: aDimension [
	
	^ self subclassResponsibility 
]

{ #category : 'initialization' }
WSLayoutStrategy class >> resetCache [
	
	^ self subclassResponsibility 
]
