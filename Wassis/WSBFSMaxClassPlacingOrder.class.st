"
BFS from startClass. startClass is the class with the max number of connections
"
Class {
	#name : 'WSBFSMaxClassPlacingOrder',
	#superclass : 'WSBFSClassPlacingOrder',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'accessing' }
WSBFSMaxClassPlacingOrder >> startClassFor: swSystem [

	^ swSystem classes detectMax: [ :each | (swSystem allConnectionsOf: each) size ]
]
