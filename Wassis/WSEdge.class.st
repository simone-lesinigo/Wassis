"
Represents and edge between two WFCNode

"
Class {
	#name : 'WSEdge',
	#superclass : 'WSObject',
	#instVars : [
		'source',
		'target',
		'direction',
		'reverseEdge'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'instance creation' }
WSEdge class >> withSource: aSourceNode withTarget: aTargetNode withDirection: aDirection [
	
	^ self new
		source: aSourceNode;
		target: aTargetNode;
		direction: aDirection.
]

{ #category : 'accessing' }
WSEdge >> direction [

	^ direction
]

{ #category : 'accessing' }
WSEdge >> direction: anObject [

	direction := anObject
]

{ #category : 'accessing' }
WSEdge >> oppositeDirection [
	
	^ reverseEdge direction
]

{ #category : 'accessing' }
WSEdge >> reverseEdge [

	^ reverseEdge
]

{ #category : 'accessing' }
WSEdge >> reverseEdge: aWFCEdge [

	reverseEdge := aWFCEdge
]

{ #category : 'accessing' }
WSEdge >> source [

	^ source
]

{ #category : 'accessing' }
WSEdge >> source: aWFCNode [

	source := aWFCNode
]

{ #category : 'accessing' }
WSEdge >> target [

	^ target
]

{ #category : 'accessing' }
WSEdge >> target: aWFCNode [

	target := aWFCNode
]
