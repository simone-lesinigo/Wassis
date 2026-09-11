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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
WSWorldUI class >> openSolution [

	| file adaptiveSolver |

	file := UIManager default
		chooseExistingFileReference: 'Select a file.fuel'
		extensions: #('fuel')
		path: (WSObject resourcesRootPath / 'solutions').

	file ifNil: [ ^ self ].

	adaptiveSolver := WSAdaptiveSolver loadFromFile: file fullName.

	WSConfig isHeadless: false.
	adaptiveSolver createVisualization.
]
