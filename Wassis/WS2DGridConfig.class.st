"
Config for a 2D grid
"
Class {
	#name : 'WS2DGridConfig',
	#superclass : 'WSConfig',
	#classVars : [
		'GridSafetyMooreRadius'
	],
	#category : 'Wassis-Config',
	#package : 'Wassis',
	#tag : 'Config'
}

{ #category : 'accessing' }
WS2DGridConfig class >> gridSafetyMooreRadius [
	
	GridSafetyMooreRadius ifNil: [ 
		self gridSafetyMooreRadius: 
			(self configFile atPath: {'WS2DGridTopology' . 'gridSafetyMooreRadius'} default: 3).
	].

	^ GridSafetyMooreRadius
]

{ #category : 'private - accessing' }
WS2DGridConfig class >> gridSafetyMooreRadius: anObject [

	GridSafetyMooreRadius := anObject
]

{ #category : 'class initialization' }
WS2DGridConfig class >> reset [ 
	
	"self configFile: nil."
	self gridSafetyMooreRadius: nil
]
