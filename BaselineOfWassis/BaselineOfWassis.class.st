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
            baseline: 'Roassal'
            with: [ 
                spec 
                    repository: 'github://pharo-graphics/Roassal:master/src';
                    loads: #('Full') ].

        spec 
            package: 'Wassis' 
            with: [ spec requires: #('PolyMath' 'Roassal') ];

			   package: 'Wassis-Tests'
			   with: [ spec requires: #('Wassis') ].
    ]
]
