"
Dictionary to store association keys (classA -> classB) and values (pathID)
"
Class {
	#name : 'ClassesPathIDDictionary',
	#superclass : 'Dictionary',
	#category : 'Wassis-Utility',
	#package : 'Wassis',
	#tag : 'Utility'
}

{ #category : 'accessing' }
ClassesPathIDDictionary >> at: anAssociation [
	
	^ super at: (self createKey: anAssociation)
	
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> at: anAssociation ifAbsent: aBlock [

   ^ super at: (self createKey: anAssociation) ifAbsent: aBlock
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> at: anAssociation ifAbsentPut: aBlock [
   
   ^ super at: (self createKey: anAssociation) ifAbsentPut: aBlock
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> at: anAssociation put: anObject [
	
   ^ super at: (self createKey:anAssociation) put: anObject
	
]

{ #category : 'creation' }
ClassesPathIDDictionary >> createKey: anAssociation [
	
	^ self keyFor: anAssociation key and: anAssociation value
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> keyFor: classA and: classB [
	
	classA id < classB id
		ifTrue: [ ^ classA -> classB ]
		ifFalse: [  ^ classB -> classA ]
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> pathIDsFor: aClass withConnections: aClassesCollection [
	"Given a class and an OrderedCollection of classes connected to that class, returns all the pathIDs of aClass"

	^ (aClassesCollection collect: [ :eachClass | self at: aClass -> eachClass ]).

]
