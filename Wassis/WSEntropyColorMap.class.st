"
When you have to visualize the entropy, you need the min, the max, the low entropy color and the high entropy color. This object holds these attributes
"
Class {
	#name : 'WSEntropyColorMap',
	#superclass : 'WSObject',
	#instVars : [
		'minEntropy',
		'maxEntropy',
		'lowEntropyColor',
		'highEntropyColor'
	],
	#category : 'Wassis-Visualization',
	#package : 'Wassis',
	#tag : 'Visualization'
}

{ #category : 'instance creation' }
WSEntropyColorMap class >> fromColor: aLowEntropyColor toColor: aHighEntropyColor [
	
	^ self new
		lowEntropyColor: aLowEntropyColor;
		highEntropyColor: aHighEntropyColor
]

{ #category : 'accessing' }
WSEntropyColorMap >> highEntropyColor [

	^ highEntropyColor
]

{ #category : 'accessing' }
WSEntropyColorMap >> highEntropyColor: anObject [

	highEntropyColor := anObject
]

{ #category : 'accessing' }
WSEntropyColorMap >> lowEntropyColor [

	^ lowEntropyColor
]

{ #category : 'accessing' }
WSEntropyColorMap >> lowEntropyColor: anObject [

	lowEntropyColor := anObject
]

{ #category : 'accessing' }
WSEntropyColorMap >> maxEntropy [

	^ maxEntropy
]

{ #category : 'accessing' }
WSEntropyColorMap >> maxEntropy: anObject [

	maxEntropy := anObject
]

{ #category : 'accessing' }
WSEntropyColorMap >> minEntropy [

	^ minEntropy
]

{ #category : 'accessing' }
WSEntropyColorMap >> minEntropy: anObject [

	minEntropy := anObject
]
