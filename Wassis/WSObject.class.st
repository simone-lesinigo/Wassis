"
The root of the WFC algorithm
"
Class {
	#name : 'WSObject',
	#superclass : 'Object',
	#category : 'Wassis-Root',
	#package : 'Wassis',
	#tag : 'Root'
}

{ #category : 'accessing' }
WSObject class >> resourcesRootPath [

	^ (IceRepository registry 
    detect: [:repo | repo name = 'wassis'])
    location / 'Wassis' / 'resources'.
]
