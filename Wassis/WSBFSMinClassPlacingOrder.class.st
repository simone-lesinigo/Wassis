"
BFS from startClass. startClass is the class with the min number of connections
"
Class {
	#name : 'WSBFSMinClassPlacingOrder',
	#superclass : 'WSBFSClassPlacingOrder',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'accessing' }
WSBFSMinClassPlacingOrder >> startClassFor: swSystem [

	^ swSystem classes detectMin: [ :each | (swSystem allConnectionsOf: each) size ]
]
