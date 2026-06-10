Class {
	#name : 'WSWorldUI',
	#superclass : 'WSObject',
	#category : 'Wassis-Visualization-Visualization',
	#package : 'Wassis-Visualization',
	#tag : 'Visualization'
}

{ #category : 'as yet unclassified' }
WSWorldUI class >> buildWorldMenuOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'Open WFC Solution')
		label: 'Open WFC Solution';
		action: [ self openSolution ];
		order: 100.
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
