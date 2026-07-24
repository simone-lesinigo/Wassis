"
The component in which a node collapse into
"
Class {
	#name : 'WSTile',
	#superclass : 'WSObject',
	#instVars : [
		'id',
		'edges',
		'weight',
		'weightPerLogWeight'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'visualization' }
WSTile >> accept: aVisitor [

	^ self subclassResponsibility 
]

{ #category : 'control' }
WSTile >> addItemToMenu: aMenu onNode: aNode usingSolver: aSolver [
	
	^ self subclassResponsibility 
]

{ #category : 'visualization' }
WSTile >> buildPopup [
	
	^ self subclassResponsibility 
]

{ #category : 'finding' }
WSTile >> directionOfSymbol: aSymbol [
	"Return the direction in which aSymbol is present. Return nil if aSymbol is not found"
		
	self edges keysAndValuesDo: [ :eachDir :eachArrayOfSymbols | 
		(eachArrayOfSymbols includes: aSymbol) ifTrue: [ ^ eachDir ]
	].
	
	^ nil
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
WSTile >> isCrossingTile [ 
	
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
WSTile >> setWeightTo: aNumber [
	
	self weight: aNumber 
]

{ #category : 'accessing' }
WSTile >> weight [

	^ weight
]

{ #category : 'accessing' }
WSTile >> weight: aNumber [

	weight := aNumber.
	weightPerLogWeight := aNumber isZero ifTrue: [ 0 ] ifFalse: [ (aNumber * (aNumber ln)) ]
]

{ #category : 'accessing' }
WSTile >> weightPerLogWeight [

	^ weightPerLogWeight
]
