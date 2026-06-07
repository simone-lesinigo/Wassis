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
ClassesPathIDDictionary >> at: source and: destination and: relationType [

    ^ super at: (self keyFor: source and: destination and: relationType)
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> at: source and: destination and: relationType ifAbsent: aBlock [

    ^ super at: (self keyFor: source and: destination and: relationType) ifAbsent: aBlock
]

{ #category : 'accessing' }
ClassesPathIDDictionary >> at: source and: destination and: relationType put: anObject [

    ^ super at: (self keyFor: source and: destination and: relationType) put: anObject
]

{ #category : 'deprecated' }
ClassesPathIDDictionary >> createKey: anAssociation [
	
	^ self keyFor: anAssociation key and: anAssociation value
]

{ #category : 'deprecated' }
ClassesPathIDDictionary >> keyFor: classA and: classB [
	
	classA id < classB id
		ifTrue: [ ^ classA -> classB ]
		ifFalse: [  ^ classB -> classA ]
]

{ #category : 'creating' }
ClassesPathIDDictionary >> keyFor: source and: destination and: relationType [

    ^ { source . destination . relationType name }
]

{ #category : 'deprecated' }
ClassesPathIDDictionary >> pathIDsFor: aClass withConnections: aClassesCollection [
	"Given a class and an OrderedCollection of classes connected to that class, returns all the pathIDs of aClass"

	^ (aClassesCollection collect: [ :eachClass | self at: aClass -> eachClass ]).

]
