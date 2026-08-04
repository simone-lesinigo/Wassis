"
Snapshot of a node in a certain moment of the execution
"
Class {
	#name : 'WSNodeSnapshot',
	#superclass : 'WSObject',
	#instVars : [
		'possibleTiles',
		'collapseStep',
		'isCollapsed',
		'entropy',
		'tileInWhichCollapsed',
		'sumOfWeights',
		'sumOfWeightsLog'
	],
	#category : 'Wassis-Snapshot',
	#package : 'Wassis',
	#tag : 'Snapshot'
}

{ #category : 'accessing' }
WSNodeSnapshot >> collapseStep [

	^ collapseStep
]

{ #category : 'accessing' }
WSNodeSnapshot >> collapseStep: anObject [

	collapseStep := anObject
]

{ #category : 'accessing' }
WSNodeSnapshot >> entropy [

	^ entropy
]

{ #category : 'accessing' }
WSNodeSnapshot >> entropy: anObject [

	entropy := anObject
]

{ #category : 'accessing' }
WSNodeSnapshot >> isCollapsed [

	^ isCollapsed
]

{ #category : 'accessing' }
WSNodeSnapshot >> isCollapsed: anObject [

	isCollapsed := anObject
]

{ #category : 'accessing' }
WSNodeSnapshot >> possibleTiles [

	^ possibleTiles
]

{ #category : 'accessing' }
WSNodeSnapshot >> possibleTiles: anObject [

	possibleTiles := anObject
]

{ #category : 'accessing' }
WSNodeSnapshot >> sumOfWeights [

	^ sumOfWeights
]

{ #category : 'accessing' }
WSNodeSnapshot >> sumOfWeights: anObject [

	sumOfWeights := anObject
]

{ #category : 'accessing' }
WSNodeSnapshot >> sumOfWeightsLog [

	^ sumOfWeightsLog
]

{ #category : 'accessing' }
WSNodeSnapshot >> sumOfWeightsLog: anObject [

	sumOfWeightsLog := anObject
]

{ #category : 'accessing' }
WSNodeSnapshot >> tileInWhichCollapsed [

	^ tileInWhichCollapsed
]

{ #category : 'accessing' }
WSNodeSnapshot >> tileInWhichCollapsed: anObject [

	tileInWhichCollapsed := anObject
]
