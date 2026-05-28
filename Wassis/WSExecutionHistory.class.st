"
Object in which it is saved the history of the execution of WFC
"
Class {
	#name : 'WSExecutionHistory',
	#superclass : 'WSObject',
	#instVars : [
		'historyOfCollapsedNodes',
		'historyOfTouchedNodes',
		'historyOfMinEntropyHeap',
		'copyOfInitalNodes',
		'historyOfFailedExectuions'
	],
	#category : 'Wassis-History',
	#package : 'Wassis',
	#tag : 'History'
}

{ #category : 'accessing' }
WSExecutionHistory >> copyOfInitalNodes [

	^ copyOfInitalNodes
]

{ #category : 'accessing' }
WSExecutionHistory >> copyOfInitalNodes: anObject [

	copyOfInitalNodes := anObject
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfCollapsedNodes [

	^ historyOfCollapsedNodes
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfCollapsedNodes: anObject [

	historyOfCollapsedNodes := anObject
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfFailedExectuions [

	^ historyOfFailedExectuions
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfFailedExectuions: anObject [

	historyOfFailedExectuions := anObject
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfMinEntropyHeap [

	^ historyOfMinEntropyHeap
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfMinEntropyHeap: anObject [

	historyOfMinEntropyHeap := anObject
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfTouchedNodes [

	^ historyOfTouchedNodes
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfTouchedNodes: anObject [

	historyOfTouchedNodes := anObject
]

{ #category : 'initialization' }
WSExecutionHistory >> initialize [ 
	super initialize.
	self historyOfCollapsedNodes: OrderedCollection new.
	self historyOfTouchedNodes: OrderedCollection new.
	self historyOfMinEntropyHeap: OrderedCollection new.
	self historyOfFailedExectuions: OrderedCollection new
]

{ #category : 'initialization' }
WSExecutionHistory >> reset [

	self historyOfCollapsedNodes: OrderedCollection new.
	self historyOfTouchedNodes: OrderedCollection new.
	self historyOfMinEntropyHeap: OrderedCollection new.
	
]
