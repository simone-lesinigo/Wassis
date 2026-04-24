"
Represents a class tile
"
Class {
	#name : 'WSClassTile',
	#superclass : 'WSTile',
	#instVars : [
		'wsClass'
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
		wsClass: aClass;
		edges: edges
]

{ #category : 'visualization' }
WSClassTile >> accept: aVisitor [

	^ aVisitor visitClassTile: self
]

{ #category : 'control' }
WSClassTile >> addItemToMenu: aMenu onNode: aNode usingSolver: aSolver [

	aMenu 
		add: 'Inspect Class' 
		target: (aNode tileInWhichCollapsed wsClass) 
		selector: #inspect
]

{ #category : 'visualization' }
WSClassTile >> buildPopup [
	
	^  RSPopup new text: [ self wsClass name asString ]
	
]

{ #category : 'initialization' }
WSClassTile >> initialize [ 
	
	super initialize.
	self weight: self class defaultWeight.
]

{ #category : 'testing' }
WSClassTile >> isClassTile [ 

	^ true
]

{ #category : 'accessing' }
WSClassTile >> wsClass [

	^ wsClass
]

{ #category : 'accessing' }
WSClassTile >> wsClass: anObject [

	wsClass := anObject
]
