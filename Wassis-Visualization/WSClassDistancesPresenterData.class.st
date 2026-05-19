"
Data that WSClassDistancesPresenter needs to work
"
Class {
	#name : 'WSClassDistancesPresenterData',
	#superclass : 'WSObject',
	#instVars : [
		'initialClassDistances',
		'classDistances',
		'composites',
		'initialCanvas'
	],
	#category : 'Wassis-Visualization-Data',
	#package : 'Wassis-Visualization',
	#tag : 'Data'
}

{ #category : 'accessing' }
WSClassDistancesPresenterData >> classDistances [

	^ classDistances
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> classDistances: anObject [

	classDistances := anObject
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> composites [

	^ composites
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> composites: anObject [

	composites := anObject
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> initialCanvas [

	^ initialCanvas
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> initialCanvas: anObject [

	initialCanvas := anObject
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> initialClassDistances [

	^ initialClassDistances
]

{ #category : 'accessing' }
WSClassDistancesPresenterData >> initialClassDistances: anObject [

	initialClassDistances := anObject
]
