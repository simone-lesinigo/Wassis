"
Represents a class in a software system
"
Class {
	#name : 'WSClass',
	#superclass : 'WSObject',
	#instVars : [
		'id',
		'name',
		'outgoingConnections',
		'incomingConnections'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'comparing' }
WSClass >> = anObject [

	^ self class = anObject class 
	    and: [(self id = anObject id) and: [ self name = anObject name ] ]
		 
]

{ #category : 'adding' }
WSClass >> addIncomingConnection: aWSlassConnection [
	
	self incomingConnections add: aWSlassConnection 
]

{ #category : 'private' }
WSClass >> addOutgoingConnection: aWSClassConnection [
	"Do not use this, use addRelation:withClass: instead. This is done so that you surely don't duplicate a connection with the same class"
	
	self outgoingConnections add: aWSClassConnection
]

{ #category : 'adding' }
WSClass >> addRelation: aRelation withClass: targetClass [
	"Add the specified relation to the connection. If the connection doesn't exist, it creates it"

	| connection |
	connection := self outgoingConnections
		              detect: [ :each | each target = targetClass ]
		              ifNone: [ nil ].
		
	connection
		ifNil: [
				| newConnection |
				newConnection := (WSClassConnection withSource: self withTarget: targetClass andRelation: aRelation).
				self addOutgoingConnection: newConnection.
				targetClass addIncomingConnection: newConnection ]
		ifNotNil: [ connection addRelation: aRelation ]
]

{ #category : 'accessing' }
WSClass >> allConnections [
	
	^ (OrderedCollection with: self incomingConnections with: self outgoingConnections) flattened 
]

{ #category : 'accessing' }
WSClass >> getConnectedWithClasses [
	"Get the classes that are in connectedWith"

	^ self outgoingConnections collect: [ :eachConnection |eachConnection target ]
]

{ #category : 'comparing' }
WSClass >> hash [
    ^ self id hash bitXor: self name hash
]

{ #category : 'accessing' }
WSClass >> id [

	^ id
]

{ #category : 'accessing' }
WSClass >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
WSClass >> incomingConnections [

	^ incomingConnections
]

{ #category : 'accessing' }
WSClass >> incomingConnections: anObject [

	incomingConnections := anObject
]

{ #category : 'initialization' }
WSClass >> initialize [

	super initialize.
	self incomingConnections: OrderedCollection new.
	self outgoingConnections: OrderedCollection new.
]

{ #category : 'accessing' }
WSClass >> name [

	^ name
]

{ #category : 'accessing' }
WSClass >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WSClass >> outgoingConnections [

	^ outgoingConnections 
]

{ #category : 'accessing' }
WSClass >> outgoingConnections: anObject [

	outgoingConnections := anObject
]
