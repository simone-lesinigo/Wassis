"
Error raised during the execution of the WFC algorithm
"
Class {
	#name : 'WSError',
	#superclass : 'Error',
	#category : 'Wassis-Error',
	#package : 'Wassis',
	#tag : 'Error'
}

{ #category : 'logging' }
WSError >> logMessage [ 
	
	^ self subclassResponsibility 
]
