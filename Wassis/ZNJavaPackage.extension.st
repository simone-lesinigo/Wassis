Extension { #name : 'ZNJavaPackage' }

{ #category : '*Wassis' }
ZNJavaPackage >> allClasses [

	^ self withAllChildren select: #isJavaClass
]
