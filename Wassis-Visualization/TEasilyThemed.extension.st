Extension { #name : 'TEasilyThemed' }

{ #category : '*Wassis-Visualization' }
TEasilyThemed >> chooseExistingFileReferences: title extensions: exts path: path [
	"Answer the result of files name chooser dialog with the given title, extensions
	to show, path and preview type."

	^ self theme
		chooseExistingFileReferencesIn: self
		title: title
		extensions: exts
		path: path
		preview: nil
]
