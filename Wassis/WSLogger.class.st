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

{ #category : 'private' }
WSLogger class >> forceLog: aString [
	
	Transcript show: aString; cr
]

{ #category : 'private' }
WSLogger class >> log: aString [
	
	WSConfig isNotHeadless ifTrue: [ Transcript show: aString; cr ]
]
