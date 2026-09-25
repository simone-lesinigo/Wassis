Class {
	#name : 'WSJavaCollector',
	#superclass : 'WSClassCollector',
	#instVars : [
		'classes',
		'filters'
	],
	#category : 'Wassis-Scraping',
	#package : 'Wassis',
	#tag : 'Scraping'
}

{ #category : 'deprecated' }
WSJavaCollector class >> filterAndLimitClasses: aCollectionOfClasses [
	| validClasses |
	validClasses := aCollectionOfClasses reject: [ :each | each isLikelyTest or: [ each isException ] ].
		
	validClasses := validClasses select: [ :each | self hasOutgoingInvocations: each within: validClasses ].
		
	^ validClasses first: (7 min: validClasses size)
]

{ #category : 'filters' }
WSJavaCollector class >> filterAndLimitClasses: aCollectionOfClasses using: someFilters [

	| validClasses |
	validClasses := (aCollectionOfClasses select: [ :each | self isValidClass: each ])
		first: (5 min: aCollectionOfClasses size).

	^ ((validClasses flatCollect: [ :eachClass |
		| related |
		related := someFilters flatCollect: [ :assoc |
			| result |
			result := assoc key value: eachClass.
			result 
				ifNil: [ { } ] 
				ifNotNil: [ 
					result isCollection
						ifTrue: [ result ]
						ifFalse: { result } ] ].
		
		related := related select: [ :each | self isValidClass: each ].
		
		related isEmpty
			ifTrue: [ { } ]
			ifFalse: [ { eachClass } , related ] ]) select: [ :each | self isValidClass: each ]) asSet
]

{ #category : 'deprecated' }
WSJavaCollector class >> filterAndLimitClasses: aCollectionOfClasses using: someFilters scope: aScope [

    | validClasses |
    validClasses := aCollectionOfClasses reject: [ :each | each isLikelyTest or: [ each isException ] ].
    validClasses := validClasses select: [ :eachClass | 
        self 
            hasMatchingEdges: eachClass 
            within: validClasses 
            using: someFilters 
            scope: aScope ].
    ^ validClasses" first: (7 min: validClasses size)"
]

{ #category : 'deprecated' }
WSJavaCollector class >> hasMatchingEdges: aClass using: someFilters [

    ^ someFilters anySatisfy: [ :filter | (filter value: aClass) notEmpty ]
]

{ #category : 'deprecated' }
WSJavaCollector class >> hasMatchingEdges: aClass within: aClassCollection using: someFilters [

    | matchingEdges |
    matchingEdges := aClass outgoingRelationships select: [ :edge |
        someFilters anySatisfy: [ :filter | filter value: edge ] ].

"    aScope = #intraPackage ifTrue: [
        matchingEdges := matchingEdges select: [ :edge |
            aClassCollection includes: edge target parent ] ]."

    ^ matchingEdges notEmpty
]

{ #category : 'deprecated' }
WSJavaCollector class >> hasMatchingEdges: aClass within: aClassCollection using: someFilters scope: aScope [

    | matchingEdges |
    matchingEdges := aClass outgoingRelationships select: [ :edge |
        someFilters anySatisfy: [ :filter | filter value: edge ] ].

    aScope = #intraPackage ifTrue: [
        matchingEdges := matchingEdges select: [ :edge |
            aClassCollection includes: edge target parent ] ].

    ^ matchingEdges notEmpty
]

{ #category : 'deprecated' }
WSJavaCollector class >> hasOutgoingInvocations: aClass within: aClassCollection [

	^ aClass outgoingInvocations anySatisfy: [ :eachInvoc | 
		aClassCollection includes: eachInvoc target parent ]
]

{ #category : 'testing' }
WSJavaCollector class >> isValidClass: aClass [
	"^ (aClass isLikelyTest 
		or: [ aClass isException 
		or: [ aClass isJavaEnum 
		or: [ aClass isJavaInterface ] ] ]) not
"
	^ (aClass isLikelyTest 
		or: [ aClass isException 
		or: [ aClass isJavaInterface ] ] ) not
]

{ #category : 'deprecated' }
WSJavaCollector class >> jsonFile: aJsonFileName forPackage: aPackageName [

    | instance package filteredClasses |
    instance := self new.
    instance graph: (ZNJavaGraph fromJsonAt: self jsonsFolder / aJsonFileName).
    
    package := instance graph modelPackages detect: [ :eachPkg | eachPkg id = aPackageName ].
    filteredClasses := self filterAndLimitClasses: package allClasses.
    instance classes: filteredClasses.
    
    ^ instance
]

{ #category : 'instance creation' }
WSJavaCollector class >> jsonFile: aJsonFileName forPackage: aPackageName using: filters [

    | instance package filteredClasses graph |
    
    graph := (ZNJavaGraph fromJsonAt: self jsonsFolder / aJsonFileName).
    
    package := graph modelPackages detect: [ :eachPkg | eachPkg id = aPackageName ].

    filteredClasses := self filterAndLimitClasses: package allClasses using: filters.

	 instance := self new classes: filteredClasses; filters: filters.

    ^ instance
]

{ #category : 'deprecated' }
WSJavaCollector class >> jsonFile: aJsonFileName forPackage: aPackageName using: someFilters scope: aScope [

    | instance package filteredClasses |
    instance := self new.
    instance graph: (ZNJavaGraph fromJsonAt: self jsonsFolder / aJsonFileName).
    
    package := instance graph modelPackages detect: [ :eachPkg | eachPkg id = aPackageName ].
    filteredClasses := self filterAndLimitClasses: package allClasses using: someFilters scope: aScope.
    instance classes: filteredClasses.

    ^ instance
]

{ #category : 'paths' }
WSJavaCollector class >> jsonsFolder [
	
	^ WSObject resourcesRootPath / 'parsedJson'
]

{ #category : 'accessing' }
WSJavaCollector >> classes [

	^ classes
]

{ #category : 'accessing' }
WSJavaCollector >> classes: anObject [

	classes := anObject
]

{ #category : 'creation' }
WSJavaCollector >> createConnectionsOn: aDictionary [

    aDictionary keysAndValuesDo: [ :aKey :aValue |
        filters do: [ :assoc |
            | result |
            result := assoc key value: aKey.

            result ifNotNil: [  
	            (result isCollection ifTrue: [ result ] ifFalse: { result }) do: [ :targetJavaClass |
	                | targetWSClass |
	                targetWSClass := aDictionary at: targetJavaClass ifAbsent: [ nil ].
	                targetWSClass ifNotNil: [
	                    targetJavaClass = aKey ifFalse: [
	                        aValue addRelation: assoc value withClass: targetWSClass
                    		]
               		 ]
            		] 
        		]
    		]
		]
]

{ #category : 'creation' }
WSJavaCollector >> createNodes [ 

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
WSJavaCollector >> filters [

	^ filters
]

{ #category : 'accessing' }
WSJavaCollector >> filters: anObject [

	filters := anObject
]
