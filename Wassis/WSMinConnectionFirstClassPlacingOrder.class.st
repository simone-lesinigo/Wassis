"
Classes are sorted based on their number of connecctions (incoming + outgoing). From MIN to MAX.
"
Class {
	#name : 'WSMinConnectionFirstClassPlacingOrder',
	#superclass : 'WSClassPlacingOrder',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSMinConnectionFirstClassPlacingOrder >> orderForSwSystem: swSystem [
		
	^ swSystem classes asSortedCollection: [ :class1 :class2 | 
		(swSystem allConnectionsOf: class1) size < (swSystem allConnectionsOf: class2) size
	]
]
