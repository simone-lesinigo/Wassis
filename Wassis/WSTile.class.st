"
The component in which a node collapse into
"
Class {
	#name : 'WSTile',
	#superclass : 'WSObject',
	#instVars : [
		'id',
		'edges',
		'weight'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'visualization' }
WSTile >> accept: aVisitor [

	^ self subclassResponsibility 
]

{ #category : 'visualization' }
WSTile >> buildPopup [
	
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
WSTile >> edges [

	^ edges
]

{ #category : 'accessing' }
WSTile >> edges: anObject [

	edges := anObject
]

{ #category : 'accessing' }
WSTile >> id [

	^ id
]

{ #category : 'accessing' }
WSTile >> id: anObject [

	id := anObject
]

{ #category : 'testing' }
WSTile >> isClassTile [
	
	^ false
]

{ #category : 'testing' }
WSTile >> isEmptyTile [
	
	^ false
]

{ #category : 'testing' }
WSTile >> isPathTile [
	
	^ false
]

{ #category : 'accessing' }
WSTile >> weight [

	^ weight
]

{ #category : 'accessing' }
WSTile >> weight: anObject [

	weight := anObject
]
