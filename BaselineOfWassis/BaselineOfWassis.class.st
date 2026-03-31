Class {
	#name : 'BaselineOfWassis',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfWassis',
	#package : 'BaselineOfWassis'
}

{ #category : 'baselines' }
BaselineOfWassis >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec
            baseline: 'PolyMath'
            with: [ spec repository: 'github://PolyMathOrg/PolyMath' ].

        spec 
            package: 'Wassis' 
            with: [ spec requires: #('PolyMath') ];

			   package: 'Wassis-Tests'
			   with: [ spec requires: #('Wassis') ].
    ]
]
