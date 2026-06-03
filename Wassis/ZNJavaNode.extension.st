Extension { #name : 'ZNJavaNode' }

{ #category : '*Wassis' }
ZNJavaNode >> incomingRelationships [

	^ self relationshipsUsing: #incomingEdges
]

{ #category : '*Wassis' }
ZNJavaNode >> outgoingInvocations [

	^ self outgoingRelationships select: #isJavaCallableInvocationEdge
]

{ #category : '*Wassis' }
ZNJavaNode >> outgoingRelationships [

	^ self relationshipsUsing: #outgoingEdges
]

{ #category : '*Wassis' }
ZNJavaNode >> relationshipsUsing: aSelector [
	
	| sourceNodes |
	sourceNodes := self withAllChildren.
	^ sourceNodes flatCollect: [ :aNode |
		(aNode perform: aSelector)
				reject: [ :anEdge | sourceNodes includes: (anEdge opposite: aNode) ]
		]
]

{ #category : '*Wassis' }
ZNJavaNode >> withAllChildren [

	^ OrderedCollection new
		add: self;
		addAll: (self children flatCollect: #withAllChildren);
		yourself
]
