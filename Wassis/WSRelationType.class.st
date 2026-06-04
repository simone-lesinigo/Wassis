"
Represents one of the type of relation between two classes (inheritance, association...)
"
Class {
	#name : 'WSRelationType',
	#superclass : 'WSObject',
	#instVars : [
		'name',
		'weight',
		'count'
	],
	#classInstVars : [
		'inheritance',
		'association',
		'usage'
	],
	#category : 'Wassis-SoftwareSystem',
	#package : 'Wassis',
	#tag : 'SoftwareSystem'
}

{ #category : 'accessing' }
WSRelationType class >> association [

	association ifNil: [
		association := 
			self new
				name: #association;
				weight: 0.5
			].

	^ association 
]

{ #category : 'accessing' }
WSRelationType class >> inheritance [

	^ self new
		name: #inheritance;
		weight: 1 
		
"	inheritance ifNil: [
		inheritance := 
			self new
				name: #inheritance;
				weight: 1 
			].

	^ inheritance"
]

{ #category : 'accessing' }
WSRelationType class >> usage [

	^ self new
		name: #usage;
		weight: 0.5

"	usage ifNil: [
		usage := 
			self new
				name: #usage;
				weight: 0.5
			].

	^ usage "
]

{ #category : 'accessing' }
WSRelationType >> count [

	^ count
]

{ #category : 'accessing' }
WSRelationType >> count: anObject [

	count := anObject
]

{ #category : 'initialization' }
WSRelationType >> initialize [ 
	
	super initialize.
	self count: 1
]

{ #category : 'accessing' }
WSRelationType >> name [

	^ name
]

{ #category : 'accessing' }
WSRelationType >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
WSRelationType >> weight [

	^ weight
]

{ #category : 'accessing' }
WSRelationType >> weight: anObject [

	weight := anObject
]
