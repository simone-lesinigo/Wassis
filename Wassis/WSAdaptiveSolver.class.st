"
Increase the size of the grid after a number of iteration
"
Class {
	#name : 'WSAdaptiveSolver',
	#superclass : 'WSObject',
	#instVars : [
		'topology',
		'swSystem',
		'solutionFound'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'initialization' }
WSAdaptiveSolver >> initialize [ 

	super initialize. 
	self solutionFound: false
]

{ #category : 'running' }
WSAdaptiveSolver >> run [
	
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
WSAdaptiveSolver >> solutionFound [

	^ solutionFound
]

{ #category : 'accessing' }
WSAdaptiveSolver >> solutionFound: anObject [

	solutionFound := anObject
]

{ #category : 'accessing' }
WSAdaptiveSolver >> swSystem [

	^ swSystem
]

{ #category : 'accessing' }
WSAdaptiveSolver >> swSystem: anObject [

	swSystem := anObject
]

{ #category : 'accessing' }
WSAdaptiveSolver >> topology [

	^ topology
]

{ #category : 'accessing' }
WSAdaptiveSolver >> topology: anObject [

	topology := anObject
]
