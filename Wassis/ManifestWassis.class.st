"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestWassis',
	#superclass : 'PackageManifest',
	#category : 'Wassis-Manifest',
	#package : 'Wassis',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestWassis class >> ruleAssignmentInIfTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#GraphWaveFunctionCollapse)) #'2026-03-09T08:27:27.399025+01:00') )
]

{ #category : 'code-critics' }
ManifestWassis class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #runDijkstraFrom:to:withExtraNodes:pathID: #false)) #'2026-03-30T16:04:57.235442+02:00') )
]

{ #category : 'code-critics' }
ManifestWassis class >> ruleModifiesCollectionRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #runDijkstraFrom:to:withExtraNodes:pathID: #false)) #'2026-03-30T16:04:54.047499+02:00') )
]
