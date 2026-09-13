Extension { #name : 'UITheme' }

{ #category : '*Wassis-Visualization' }
UITheme >> chooseExistingFileReferencesIn: aThemedMorph title: title extensions: exts path: path preview: preview [
	| dialog window |  
	dialog := self fileDialogWindowClass new.  
	dialog beMultipleSelection.  
	exts ifNotNil: [ dialog filter: (StCustomExtensionsFilter extensions: exts) ].  
	path ifNotNil: [ dialog nameText: path basename ].  
	dialog  
		defaultFolder: (path ifNil: [ StFileSystemModel defaultDirectory ]);  
		title: (title ifNil: [ 'Choose Files' translated ]).

	window := dialog asModalWindow.
	window initialExtent: 1300 @ 600.
	window open.

	^ dialog cancelled  
		  ifTrue: [ nil ]  
		  ifFalse: [ dialog selectedEntries ]
]
