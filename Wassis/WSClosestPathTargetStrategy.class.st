"
Selects the closest class to which it should be connected on the grid, and assigns its corresponding node (matching the same pathID) as the target
"
Class {
	#name : 'WSClosestPathTargetStrategy',
	#superclass : 'WSPathTargetStrategy',
	#category : 'Wassis-Path Target',
	#package : 'Wassis',
	#tag : 'Path Target'
}

{ #category : 'finding' }
WSClosestPathTargetStrategy >> findTargetNodeFor: aClass pathID: aPathID node: aNode topology: aTopology [
    "Return the closest border node among all footprints sharing aPathID, excluding aClass"

    | connectedClasses bestNode bestDistance |
    connectedClasses := aTopology swSystem allClassesConnectedByPathID: aPathID.
    bestNode := nil.
    bestDistance := SmallInteger maxVal.

    (connectedClasses reject: [ :each | each = aClass ]) do: [ :eachConnectedClass |
        | targetNode currentDistance |
        targetNode := self targetNodeFor: eachConnectedClass pathID: aPathID topology: aTopology.
        targetNode ifNotNil: [
            currentDistance := aTopology distanceBetweenNode: aNode toNode: targetNode.
            currentDistance < bestDistance ifTrue: [
                bestDistance := currentDistance.
                bestNode := targetNode ] ] ].

    ^ bestNode
]

{ #category : 'finding' }
WSClosestPathTargetStrategy >> targetNodeFor: aClass pathID: aPathID topology: aTopology [
    "Return the border node of aClass's footprint matching aPathID, or nil if absent"

    | footprint |
    footprint := aTopology classFootprint at: aClass ifAbsent: [ ^ nil ].

    ^ footprint nodeThatIncludes: aPathID
]
