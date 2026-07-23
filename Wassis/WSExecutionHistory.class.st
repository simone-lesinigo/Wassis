"
Object in which it is saved the history of the execution of WFC
"
Class {
	#name : 'WSExecutionHistory',
	#superclass : 'WSObject',
	#instVars : [
		'historyOfCollapsedNodes',
		'historyOfTouchedNodes',
		'historyOfEntropyHeap',
		'copyOfInitalNodes',
		'historyOfFailedExecutions'
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
WSExecutionHistory >> historyOfEntropyHeap [

	^ historyOfEntropyHeap
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfEntropyHeap: anObject [

	historyOfEntropyHeap := anObject
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfFailedExecutions [

	^ historyOfFailedExecutions
]

{ #category : 'accessing' }
WSExecutionHistory >> historyOfFailedExecutions: anObject [

	historyOfFailedExecutions := anObject
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
	self historyOfEntropyHeap: OrderedCollection new.
	self historyOfFailedExecutions: OrderedCollection new
]

{ #category : 'initialization' }
WSExecutionHistory >> reset [

	self historyOfCollapsedNodes: OrderedCollection new.
	self historyOfTouchedNodes: OrderedCollection new.
	self historyOfEntropyHeap: OrderedCollection new.
	
]

{ #category : 'initialization' }
WSExecutionHistory >> truncateTo: aSize [
	
	self historyOfCollapsedNodes: (self historyOfCollapsedNodes copyFrom: 1 to: aSize). 
	self historyOfTouchedNodes: (self historyOfTouchedNodes copyFrom: 1 to: aSize).
	self historyOfEntropyHeap: (self historyOfEntropyHeap copyFrom: 1 to: aSize).
]
