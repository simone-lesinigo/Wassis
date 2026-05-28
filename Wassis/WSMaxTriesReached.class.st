"
Error raised when the maximum number for a size is reached
"
Class {
	#name : 'WSMaxTriesReached',
	#superclass : 'WSError',
	#category : 'Wassis-Error',
	#package : 'Wassis',
	#tag : 'Error'
}

{ #category : 'logging' }
WSMaxTriesReached >> logMessage [

    ^ 'Max n of tries reached for this grid'
]
