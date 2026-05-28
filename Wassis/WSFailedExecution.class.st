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
		'copyOfNodes'
	],
	#category : 'Wassis-History',
	#package : 'Wassis',
	#tag : 'History'
}

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
