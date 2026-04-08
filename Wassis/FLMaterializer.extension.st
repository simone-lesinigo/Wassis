Extension { #name : 'FLMaterializer' }

{ #category : '*Wassis' }
FLMaterializer class >> materializeFromFileNamedIgnoringMethodChanges: aFilePath [
	^ self new
		disableMethodChangedWarning 
		filePath: aFilePath;
		materializeRoot

]
