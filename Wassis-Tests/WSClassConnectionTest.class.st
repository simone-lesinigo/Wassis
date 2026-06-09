Class {
	#name : 'WSClassConnectionTest',
	#superclass : 'WSTest',
	#category : 'Wassis-Tests',
	#package : 'Wassis-Tests'
}

{ #category : 'tests' }
WSClassConnectionTest >> testAddRelation [
	
	| class1 class2 |
	class1 := WSClass new.
	class2 := WSClass new.
	
	class1 addOutgoingConnection: 
		(WSClassConnection 
			withTarget: class2 
			andRelation: WSRelationType inheritance).
			
	class1 addRelation: WSRelationType usage withClass: class2.
	
	
	
]

{ #category : 'tests' }
WSClassConnectionTest >> testAddRelationNoConnection [
	
	| class1 class2 |
	class1 := WSClass new.
	class2 := WSClass new.
			
	class1 addRelation: WSRelationType usage withClass: class2
	
	
	
]

{ #category : 'tests' }
WSClassConnectionTest >> testRelationsWeight [
	
	| class1 class2 weight |
	class1 := WSClass new.
	class2 := WSClass new.
	
	class1 addOutgoingConnection: 
		(WSClassConnection 
			withTarget: class2 
			andRelations: {WSRelationType inheritance . WSRelationType association }).
			
	weight := class1 outgoingConnections first weight.
	self assert: weight equals: 1.5
	
	
	
]
