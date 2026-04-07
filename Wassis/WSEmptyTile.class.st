"
Represents an empty tile
"
Class {
	#name : 'WSEmptyTile',
	#superclass : 'WSTile',
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'default-settings' }
WSEmptyTile class >> defaultID [
	
	^ 0
]

{ #category : 'default-settings' }
WSEmptyTile class >> defaultWeight [
	
	 ^ 4000
]

{ #category : 'instance creation' }
WSEmptyTile class >> withEdges: edges [
	
	^ self new
		edges: edges
]

{ #category : 'visualization' }
WSEmptyTile >> accept: aVisitor [
	
	^ aVisitor visitEmptyTile: self
]

{ #category : 'initialization' }
WSEmptyTile >> initialize [ 
	
	super initialize.
	self 
		id: self class defaultID;
		weight: self class defaultWeight 
]

{ #category : 'testing' }
WSEmptyTile >> isEmptyTile [ 
	
	^ true
]
