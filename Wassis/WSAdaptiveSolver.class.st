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
		'solver',
		'historyOfFailedExecutions'
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

    ^ (WSObject resourcesRootPath / 'solutions' / ('solution-', DateAndTime nowAsString, '.fuel')) fullName
]

{ #category : 'visualization' }
WSAdaptiveSolver >> createVisualization [ 
	
	self solver createVisualizationWith: self
]

{ #category : 'accessing' }
WSAdaptiveSolver >> historyOfFailedExecutions [

	^ historyOfFailedExecutions
]

{ #category : 'accessing' }
WSAdaptiveSolver >> historyOfFailedExecutions: anObject [

	historyOfFailedExecutions := anObject
]

{ #category : 'initialization' }
WSAdaptiveSolver >> initialize [ 

	super initialize. 
	self solutionFound: false.
	self historyOfFailedExecutions: Dictionary new.
]

{ #category : 'running' }
WSAdaptiveSolver >> run [
	
	^ self subclassResponsibility 
]

{ #category : 'saving' }
WSAdaptiveSolver >> save [

	self serializeToFileNamed: self class savePath.
	
	GrowlMorph new
		label: 'Information' contents: 'Solution saved succesfully ✓';
		textColor: Color black;
		backgroundColor: Color green;
		openInWorld 
]

{ #category : 'saving' }
WSAdaptiveSolver >> saveFailedExecutionHistory [
	"Add to the collection of failed execution at a certain dimension the failed executions of the current solver before erasing it"
	
	self solver ifNotNil: [ 
		(self historyOfFailedExecutions at: self solver dimension ifAbsentPut: [ OrderedCollection new ])
			addAll: self solver executionHistory historyOfFailedExecutions ]
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
