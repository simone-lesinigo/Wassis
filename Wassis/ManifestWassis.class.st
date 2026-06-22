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
ManifestWassis class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #buildDijkstraEdgesFor:onNodes:zeroNodes: #false)) #'2026-05-20T16:06:04.747638+02:00') )
]

{ #category : 'code-critics' }
ManifestWassis class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #runDijkstraFrom:to:withExtraNodes:pathID: #false)) #'2026-03-31T14:44:00.417506+02:00') #(#(#RGMethodDefinition #(#WSGraph #updateExitFor:withPathID: #false)) #'2026-04-01T16:30:50.230472+02:00') #(#(#RGMethodDefinition #(#WS2DRectangularGridTopology #buildAvailableSlotsFor: #false)) #'2026-04-10T15:08:02.6527+02:00') #(#(#RGMethodDefinition #(#WSGraph #runDijkstraFrom:to:withExtraNodes: #false)) #'2026-04-20T16:49:37.701565+02:00') #(#(#RGMethodDefinition #(#WSGraph #correctPaths #false)) #'2026-04-28T09:57:44.168605+02:00') #(#(#RGMethodDefinition #(#WS2DRectangularGridTopology #buildTileSpecsForPathID: #false)) #'2026-04-28T20:03:07.400643+02:00') #(#(#RGMethodDefinition #(#WSGraph #substituteMergedPath:with: #false)) #'2026-05-21T12:37:39.003957+02:00') #(#(#RGMethodDefinition #(#WSSolver #classifyPathTiles #false)) #'2026-05-25T18:41:02.929867+02:00') #(#(#RGMethodDefinition #(#WSTileset #createTileForDirections:pathIDs: #false)) #'2026-05-25T20:05:35.316534+02:00') #(#(#RGMethodDefinition #(#WSSoftwareSystem #createPathIDsFromClassesAllowinMerge #false)) #'2026-06-22T10:02:05.500947+02:00') #(#(#RGMethodDefinition #(#WSSoftwareSystem #createAllConnectionsPerClass #false)) #'2026-06-22T10:41:44.265469+02:00') #(#(#RGMethodDefinition #(#WS2DRectangularGridTopology #computeConnectionDirectionsFor:withFootprint: #false)) #'2026-06-22T16:44:09.972751+02:00') )
]

{ #category : 'code-critics' }
ManifestWassis class >> ruleModifiesCollectionRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #runDijkstraFrom:to:withExtraNodes:pathID: #false)) #'2026-03-31T14:43:57.955716+02:00') #(#(#RGMethodDefinition #(#WS2DRectangularGridVisualizer #addGroupHoverTo: #false)) #'2026-04-08T17:20:22.802378+02:00') #(#(#RGMethodDefinition #(#WSGraph #runDijkstraFrom:to:withExtraNodes: #false)) #'2026-04-20T16:49:34.41926+02:00') #(#(#RGMethodDefinition #(#WSMetricMDSLayoutStrategy #computeBMatrixFor: #false)) #'2026-05-20T09:48:06.757867+02:00') #(#(#RGMethodDefinition #(#WSGraph #buildDijkstraEdgesFor:onNodes: #false)) #'2026-05-20T15:54:48.882537+02:00') #(#(#RGMethodDefinition #(#WSGraph #buildDijkstraEdgesFor:onNodes:zeroNodes: #false)) #'2026-05-20T16:06:09.715499+02:00') #(#(#RGMethodDefinition #(#'WSJetUmlCollector class' #filterAndLimitClasses:using:scope: #true)) #'2026-06-05T10:47:57.011974+02:00') #(#(#RGMethodDefinition #(#'WSJavaCollector class' #filterAndLimitClasses:using: #true)) #'2026-06-05T12:57:13.160506+02:00') )
]

{ #category : 'code-critics' }
ManifestWassis class >> ruleReGuardClauseRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #createPathFrom: #false)) #'2026-04-13T09:39:43.872158+02:00') #(#(#RGMethodDefinition #(#WSGraph #followPath:from:visited:pathID: #false)) #'2026-04-19T10:18:50.309636+02:00') #(#(#RGMethodDefinition #(#WS2DRectangularGridVisualizer #createVisualizationFor: #false)) #'2026-05-15T11:57:02.162738+02:00') )
]

{ #category : 'code-critics' }
ManifestWassis class >> ruleUnclassifiedMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#WSGraph #buildDijkstraEdgesFor:onNodes:zeroNodes: #false)) #'2026-05-20T16:06:06.881351+02:00') )
]
