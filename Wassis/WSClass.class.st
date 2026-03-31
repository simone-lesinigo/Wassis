"
Represents a class in a software system
"
Class {
	#name : 'WSClass',
	#superclass : 'WSObject',
	#instVars : [
		'id',
		'name',
		'connectedWith'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'comparing' }
WSClass >> = anObject [

^ self class = anObject class 
    and: [ self id = anObject id ]
]

{ #category : 'private' }
WSClass >> addConnection: aWFCClassConnection [
	"Do not use this, use addRelation:withClass: instead. This is done so that you surely don't duplicate a connection with the same class"
	
	self connectedWith add: aWFCClassConnection
]

{ #category : 'adding' }
WSClass >> addRelation: aRelation withClass: aClass [
	"Add the specified relation to the connection. If the connection doesn't exist, it creates it"

	| connection |
	connection := self connectedWith
		              detect: [ :each | each target = aClass ]
		              ifNone: [ nil ].

	connection
		ifNil: [
				self addConnection:
					(WSClassConnection withTarget: aClass andRelation: aRelation) ]
		ifNotNil: [ connection addRelation: aRelation ]
]

{ #category : 'accessing' }
WSClass >> connectedWith [

	^ connectedWith
]

{ #category : 'accessing' }
WSClass >> connectedWith: anObject [

	connectedWith := anObject
]

{ #category : 'comparing' }
WSClass >> hash [
    ^ self id hash
]

{ #category : 'accessing' }
WSClass >> id [

	^ id
]

{ #category : 'accessing' }
WSClass >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
WSClass >> initialize [

	super initialize.
	self connectedWith: OrderedCollection new
]

{ #category : 'accessing' }
WSClass >> name [

	^ name
]

{ #category : 'accessing' }
WSClass >> name: anObject [

	name := anObject
]
