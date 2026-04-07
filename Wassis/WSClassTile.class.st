"
Represents a class tile
"
Class {
	#name : 'WSClassTile',
	#superclass : 'WSTile',
	#instVars : [
		'wfcClass'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'default-settings' }
WSClassTile class >> defaultWeight [
	
	^ 1
]

{ #category : 'instance creation' }
WSClassTile class >> withClass: aClass andEdges: edges [
	
	^ self new
		id: aClass id;
		wfcClass: aClass;
		edges: edges
]

{ #category : 'instance creation' }
WSClassTile class >> withID: anID andEdges: edges [
	
	^ self new
		id: anID;
		edges: edges
]

{ #category : 'visualization' }
WSClassTile >> accept: aVisitor [

	^ aVisitor visitClassTile: self
]

{ #category : 'initialization' }
WSClassTile >> initialize [ 
	
	super initialize.
	self weight: self class defaultWeight 
]

{ #category : 'testing' }
WSClassTile >> isClassTile [ 

	^ true
]

{ #category : 'accessing' }
WSClassTile >> wfcClass [

	^ wfcClass
]

{ #category : 'accessing' }
WSClassTile >> wfcClass: anObject [

	wfcClass := anObject
]
