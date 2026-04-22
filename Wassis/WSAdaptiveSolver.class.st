"
Increase the size of the grid after a number of iteration
"
Class {
	#name : 'WSAdaptiveSolver',
	#superclass : 'WSObject',
	#instVars : [
		'topology',
		'swSystem',
		'solutionFound',
		'solver'
	],
	#category : 'Wassis-Core',
	#package : 'Wassis',
	#tag : 'Core'
}

{ #category : 'serializing' }
WSAdaptiveSolver class >> loadFromFile: aFilePath [

	^ FLMaterializer materializeFromFileNamedIgnoringMethodChanges: aFilePath 
]

{ #category : 'serializing' }
WSAdaptiveSolver class >> savePath [

    ^ WSObject rootPath, 'solution-', DateAndTime nowAsString, '.fuel'
]

{ #category : 'initialization' }
WSAdaptiveSolver >> initialize [ 

	super initialize. 
	self solutionFound: false
]

{ #category : 'running' }
WSAdaptiveSolver >> run [
	
	^ self subclassResponsibility 
]

{ #category : 'actions' }
WSAdaptiveSolver >> save [

	self serializeToFileNamed: self class savePath
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
WSAdaptiveSolver >> solver [

	^ solver
]

{ #category : 'accessing' }
WSAdaptiveSolver >> solver: anObject [

	solver := anObject
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
