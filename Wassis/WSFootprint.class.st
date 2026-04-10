"
A class node has a footprint, as it can be composed of multiple nodes (to increase the number of exits it can have)
"
Class {
	#name : 'WSFootprint',
	#superclass : 'WSObject',
	#instVars : [
		'wsClass',
		'nodes',
		'originNode',
		'sideLength'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'accessing' }
WSFootprint >> centerNode [
    "Return the center node of the footprint. If N is even, return one of the 4 central nodes at random."
    
    | mid centerRow centerCol candidates |
    mid := self sideLength // 2.
    
    self sideLength odd ifTrue: [
        centerRow := self originNode row + mid.
        centerCol := self originNode column + mid.
        ^ self nodes detect: [ :eachNode | eachNode row = centerRow and: [ eachNode column = centerCol ] ] ].
    
    centerRow := self originNode row + mid - 1.
    centerCol := self originNode column + mid - 1.
    candidates := self nodes select: [ :eachNode |
        (eachNode row = centerRow or: [ eachNode row = (centerRow + 1) ]) and: [
        (eachNode column = centerCol or: [ eachNode column = (centerCol + 1) ]) ] ].
    ^ candidates atRandom
]

{ #category : 'accessing' }
WSFootprint >> nodes [

	^ nodes
]

{ #category : 'accessing' }
WSFootprint >> nodes: anObject [

	nodes := anObject
]

{ #category : 'accessing' }
WSFootprint >> originNode [

	^ originNode
]

{ #category : 'accessing' }
WSFootprint >> originNode: anObject [

	originNode := anObject
]

{ #category : 'accessing' }
WSFootprint >> sideLength [

	^ sideLength
]

{ #category : 'accessing' }
WSFootprint >> sideLength: anObject [

	sideLength := anObject
]

{ #category : 'accessing' }
WSFootprint >> wsClass [

	^ wsClass
]

{ #category : 'accessing' }
WSFootprint >> wsClass: anObject [

	wsClass := anObject
]
