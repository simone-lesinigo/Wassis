Class {
	#name : 'WSClassConnectionTest',
	#superclass : 'WSTest',
	#category : 'Wassis-Tests',
	#package : 'Wassis-Tests'
}

{ #category : 'tests' }
WSClassConnectionTest >> testAddRelation [
	
	| class1 class2 |
	class1 := WFCClass new.
	class2 := WFCClass new.
	
	class1 addConnection: 
		(WFCClassConnection 
			withTarget: class2 
			andRelation: WFCRelationType inheritance).
			
	class1 addRelation: WFCRelationType usage withClass: class2.
	
	
	
]

{ #category : 'tests' }
WSClassConnectionTest >> testAddRelationNoConnection [
	
	| class1 class2 |
	class1 := WFCClass new.
	class2 := WFCClass new.
			
	class1 addRelation: WFCRelationType usage withClass: class2
	
	
	
]

{ #category : 'tests' }
WSClassConnectionTest >> testRelationsWeight [
	
	| class1 class2 weight |
	class1 := WFCClass new.
	class2 := WFCClass new.
	
	class1 addConnection: 
		(WFCClassConnection 
			withTarget: class2 
			andRelations: {WFCRelationType inheritance . WFCRelationType association }).
			
	weight := class1 connectedWith first weight.
	self assert: weight equals: 1.5
	
	
	
]
