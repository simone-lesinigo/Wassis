"
Decide in which order the classes are placed on the grid
"
Class {
	#name : 'WSClassPlacingOrder',
	#superclass : 'WSObject',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSClassPlacingOrder >> orderForSwSystem: swSystem [
	
	^ self subclassResponsibility
]
