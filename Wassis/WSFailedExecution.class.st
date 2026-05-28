"
Represents a failed execution of WFC
"
Class {
	#name : 'WSFailedExecution',
	#superclass : 'WSObject',
	#instVars : [
		'timestamp',
		'numberOfTry',
		'numberOfCollapsedNodes',
		'totalNumberOfNodes',
		'numberOfUncollapsedNodes',
		'copyOfNodes'
	],
	#category : 'Wassis-History',
	#package : 'Wassis',
	#tag : 'History'
}

{ #category : 'instance creation' }
WSFailedExecution class >> timestamp: aTimestamp nOfTry: numberOfTry nOfCollapsedNodes: nOfCollapsedNodes copyOfNodes: copyOfNodes [
	
	^ self new
		timestamp: aTimestamp;
		numberOfTry: numberOfTry;
	   numberOfCollapsedNodes: nOfCollapsedNodes;
	   totalNumberOfNodes: copyOfNodes size;
		numberOfUncollapsedNodes: copyOfNodes size - nOfCollapsedNodes;
	   copyOfNodes: copyOfNodes
]

{ #category : 'accessing' }
WSFailedExecution >> copyOfNodes [

	^ copyOfNodes
]

{ #category : 'accessing' }
WSFailedExecution >> copyOfNodes: anObject [

	copyOfNodes := anObject
]

{ #category : 'accessing' }
WSFailedExecution >> numberOfCollapsedNodes [

	^ numberOfCollapsedNodes
]

{ #category : 'accessing' }
WSFailedExecution >> numberOfCollapsedNodes: anObject [

	numberOfCollapsedNodes := anObject
]

{ #category : 'accessing' }
WSFailedExecution >> numberOfTry [

	^ numberOfTry
]

{ #category : 'accessing' }
WSFailedExecution >> numberOfTry: anObject [

	numberOfTry := anObject
]

{ #category : 'accessing' }
WSFailedExecution >> numberOfUncollapsedNodes [

	^ numberOfUncollapsedNodes
]

{ #category : 'accessing' }
WSFailedExecution >> numberOfUncollapsedNodes: anObject [

	numberOfUncollapsedNodes := anObject
]

{ #category : 'accessing' }
WSFailedExecution >> timestamp [

	^ timestamp
]

{ #category : 'accessing' }
WSFailedExecution >> timestamp: anObject [

	timestamp := anObject
]

{ #category : 'accessing' }
WSFailedExecution >> totalNumberOfNodes [

	^ totalNumberOfNodes
]

{ #category : 'accessing' }
WSFailedExecution >> totalNumberOfNodes: anObject [

	totalNumberOfNodes := anObject
]
