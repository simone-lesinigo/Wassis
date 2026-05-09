"
Logger to show things in the transcript
"
Class {
	#name : 'WSLogger',
	#superclass : 'WSObject',
	#category : 'Wassis-Log',
	#package : 'Wassis',
	#tag : 'Log'
}

{ #category : 'logging' }
WSLogger class >> log: aString [
	
	Transcript show: aString.
	WSConfig isHeadless ifTrue: [ Transcript show: (' - PID: {1}' format: {LibC uniqueInstance getpid asString}) ].
	Transcript cr
]
