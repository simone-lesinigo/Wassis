"
Represents the types of connections between two classes
"
Class {
	#name : 'WSClassConnection',
	#superclass : 'WSObject',
	#instVars : [
		'source',
		'target',
		'relations'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'instance creation' }
WSClassConnection class >> withSource: aSource withTarget: aTarget andRelation: aRelation [
	
	| newInstance |
	newInstance :=  self new source: aSource; target: aTarget.
	newInstance addRelation: aRelation.

	^ newInstance.
]

{ #category : 'instance creation' }
WSClassConnection class >> withSource: aSource withTarget: aTarget andRelations: aRelationsArray [
	
	| newInstance |
	newInstance := self new source: aSource; target: aTarget.
	newInstance relations addAll: aRelationsArray.

	^ newInstance.
]

{ #category : 'deprecated' }
WSClassConnection class >> withTarget: aTarget andRelation: aRelation [
	
	| newInstance |
	newInstance := self new target: aTarget.
	newInstance addRelation: aRelation.

	^ newInstance.
]

{ #category : 'deprecated' }
WSClassConnection class >> withTarget: aTarget andRelations: aRelationsArray [
	
	| newInstance |
	newInstance := self new target: aTarget.
	newInstance relations addAll: aRelationsArray.

	^ newInstance.
]

{ #category : 'adding' }
WSClassConnection >> addRelation: aRelation [
	
	self relations 
		detect: [ :eachRelation | aRelation name = eachRelation name ]
		ifFound: [ :foundRelation | 
			foundRelation count: foundRelation count + 1.
			foundRelation weight: foundRelation weight + aRelation weight ]
		ifNone: [ self relations add: aRelation  ].
	
]

{ #category : 'initialization' }
WSClassConnection >> initialize [ 
	
	super initialize.
	self relations: OrderedCollection new.
]

{ #category : 'accessing' }
WSClassConnection >> relations [

	^ relations
]

{ #category : 'accessing' }
WSClassConnection >> relations: anObject [

	relations := anObject
]

{ #category : 'accessing' }
WSClassConnection >> source [

	^ source
]

{ #category : 'accessing' }
WSClassConnection >> source: anObject [

	source := anObject
]

{ #category : 'accessing' }
WSClassConnection >> target [

	^ target
]

{ #category : 'accessing' }
WSClassConnection >> target: anObject [

	target := anObject
]

{ #category : 'calculating' }
WSClassConnection >> weight [
	"Returns the sum of the weights of the collection"
		
	| sum |
	sum := 0.
	
	self relations do: [ :eachRel | sum := sum + (eachRel weight) ].
	
	^ sum
]
