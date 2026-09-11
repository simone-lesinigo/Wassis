"
Add items to the top menu
"
Class {
	#name : 'WSWorldUI',
	#superclass : 'WSObject',
	#category : 'Wassis-Visualization-WorldMenu',
	#package : 'Wassis-Visualization',
	#tag : 'WorldMenu'
}

{ #category : 'world menu' }
WSWorldUI class >> buildWorldMenuOn: aBuilder [
	<worldMenu>

	(aBuilder item: #Wassis)
		label: 'Wassis';
		iconName: #glamorousGo;
		order: 100.
		
	(aBuilder item: #'OpenSolution')
		parent: #Wassis;
		label: 'Open Solution';
		iconName: #open;
		action: [ self openSolution ];
		order: 10.
		
	(aBuilder item: #GenerateVisualization)
		"parent: #Wassis;"
		label: 'Generate Hierarchy Visualization';
		iconName: #hierarchy;
		action: [ WSClassSelectionPresenter open ];
		order: 200.
]

{ #category : 'testing' }
WSWorldUI class >> isTranscriptOpen [

	^ self currentWorld submorphs anySatisfy: [ :aMorph | 
		(aMorph isKindOf: SystemWindow) 
			and: [ aMorph isCollapsed not 
				and: [ aMorph label notNil 
					and: [ aMorph label asString = 'Transcript' ] ] ] ]
]

{ #category : 'opening' }
WSWorldUI class >> openSolution [

	| files |

	files := UIManager default
		chooseExistingFileReferences: 'Select files'
		extensions: #('fuel')
		path: (WSObject resourcesRootPath / 'solutions').

	(files isNil or: [ files isEmpty ]) ifTrue: [ ^ self ].
	
	WSConfig isHeadless: false.
	
	files do: [ :eachFile | 	
			| adaptiveSolver |
			adaptiveSolver := WSAdaptiveSolver loadFromFile: eachFile fullName. 
			adaptiveSolver createVisualization.
	]
]
