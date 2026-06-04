Class {
	#name : 'WSJetUmlCollector',
	#superclass : 'WSClassCollector',
	#instVars : [
		'graph',
		'classes'
	],
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'instance creation' }
WSJetUmlCollector class >> forPackage: aPackage [
	
	^ self new package: aPackage 
]

{ #category : 'instance creation' }
WSJetUmlCollector class >> jsonFile: aJsonFileName forPackage: aPackageName [
	
	| instance package classes |
	instance := self new.
	instance graph: (ZNJavaGraph fromJsonAt: FileLocator desktop / aJsonFileName).
	package := (instance graph modelPackages detect: [ :eachPkg | eachPkg id = aPackageName ]).
	classes := package allClasses.
	classes := classes reject: [ :eachClass | eachClass isLikelyTest or: [ eachClass isException ] ].
	classes := classes select: [ :eachClass | eachClass outgoingInvocations anySatisfy: [ :eachInvoc | classes includes: eachInvoc target parent ] ].
	classes := classes first: 7.
	instance classes: classes.
	
	^ instance
]

{ #category : 'paths' }
WSJetUmlCollector class >> jsonsFolder [
	
	^ WSObject resourcesRootPath / 'parsedJson'
]

{ #category : 'accessing' }
WSJetUmlCollector >> classes [

	^ classes
]

{ #category : 'accessing' }
WSJetUmlCollector >> classes: anObject [

	classes := anObject
]

{ #category : 'creation' }
WSJetUmlCollector >> createConnectionsOn: aDictionary [
	
	aDictionary keysAndValuesDo: [ :aKey : aValue | 
		aKey outgoingInvocations do: [ :eachInvocation |
			| targetJavaClass targetWSClass |
			targetJavaClass := eachInvocation target parent.
			targetWSClass := aDictionary at: targetJavaClass ifAbsent: [ nil ].
			targetWSClass ifNotNil: [  
				targetJavaClass = aKey ifFalse: [
	             aValue addRelation: WSRelationType usage withClass: targetWSClass
			]
			]
		]
	]
]

{ #category : 'creation' }
WSJetUmlCollector >> createNodes [ 

	| dict id | 
	dict := Dictionary new.
	id := 1.
	
	classes do: 
		[ :eachClass | 
			dict at: eachClass put: (WSClass new id: id; name: eachClass name).
			id := id + 1 ] .
	
	^ dict
	
]

{ #category : 'accessing' }
WSJetUmlCollector >> graph [

	^ graph
]

{ #category : 'accessing' }
WSJetUmlCollector >> graph: anObject [

	graph := anObject
]
