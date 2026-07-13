"
BFS from startClass
"
Class {
	#name : 'WSBFSClassPlacingOrder',
	#superclass : 'WSClassPlacingOrder',
	#category : 'Wassis-Placement',
	#package : 'Wassis',
	#tag : 'Placement'
}

{ #category : 'calculating' }
WSBFSClassPlacingOrder >> orderForSwSystem: swSystem [
	"BFS from startClass"

	| startClass visited queue result |
	startClass := self startClassFor: swSystem.

	result := OrderedCollection new.
	visited := Set with: startClass.
	queue := OrderedCollection with: startClass.

	[ queue notEmpty ] whileTrue: [
		| current neighbors |
		current := queue removeFirst.
		result add: current.

		neighbors := (swSystem allConnectionsOf: current) reject: [ :each | visited includes: each ].
		neighbors do: [ :each |
			visited add: each.
			queue addLast: each ] ].

	swSystem classes do: [ :each |
		(visited includes: each) ifFalse: [
			result add: each.
			visited add: each ] ].
	^ result
]

{ #category : 'calculating' }
WSBFSClassPlacingOrder >> startClassFor: swSystem [

	^ self subclassResponsibility
]
