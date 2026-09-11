"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestWassisVisualization',
	#superclass : 'PackageManifest',
	#category : 'Wassis-Visualization-Manifest',
	#package : 'Wassis-Visualization',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestWassisVisualization class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'WSWorldUI class' #isTranscriptOpen #true)) #'2026-09-11T09:45:05.326357+02:00') )
]
