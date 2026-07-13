"
Classes get shuffled
"
Class {
	#name : 'WSRandomClassPlacingOrder',
	#superclass : 'WSClassPlacingOrder',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSRandomClassPlacingOrder >> orderForSwSystem: swSystem [
	
	^ swSystem classes shuffled
]
