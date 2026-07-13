"
Classes are sorted based on their number of connecctions (incoming + outgoing). From MAX to MIN.
"
Class {
	#name : 'WSMaxConnectionFirstClassPlacingOrder',
	#superclass : 'WSClassPlacingOrder',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSMaxConnectionFirstClassPlacingOrder >> orderForSwSystem: swSystem [
		
	^ swSystem classes asSortedCollection: [ :class1 :class2 | 
		(swSystem allConnectionsOf: class1) size > (swSystem allConnectionsOf: class2) size
	]
]
