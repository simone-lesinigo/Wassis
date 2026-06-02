Class {
	#name : 'BaselineOfWassis',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfWassis',
	#package : 'BaselineOfWassis'
}

{ #category : 'baselines' }
BaselineOfWassis >> baseline: spec [
    <baseline>
	 
	 self loadZION.
		
    spec for: #common do: [
        spec
            baseline: 'PolyMath'
            with: [ spec repository: 'github://PolyMathOrg/PolyMath' ].

		  spec 
				baseline: 'NeoJSON'
				 with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

		  spec
            baseline: 'Roassal'
            with: [
            		spec
                	repository: (self classNamed: #BaselineOfPharo) roassalRepository;
                	loads: #( 'Full' ) ].	
	
		 	spec 
				baseline: 'RoassalExporters'
				with: [ spec repository: 'github://pharo-graphics/RoassalExporters' ].

        spec 
            package: 'Wassis' 
            with: [ spec requires: #('PolyMath' 'Roassal' 'NeoJSON') ];

            package: 'Wassis-Visualization'
            with: [ spec requires: #('Wassis' 'RoassalExporters') ];

            package: 'Wassis-Tests'
            with: [ spec requires: #('Wassis') ].
    ]
]

{ #category : 'loading' }
BaselineOfWassis >> loadZION [

	| repositoryPath repo |
	repositoryPath := FileLocator localDirectory / 'iceberg' / 'research' / 'zion'.
	repo := IceRepositoryCreator new
	     url: 'ssh://git@gitlab.reveal.si.usi.ch:60022/research/zion.git';
	     location: repositoryPath asFileReference;
	     createRepository.
	repo register.

	Metacello new
	     baseline: 'ZION';
	     repository: 'gitlocal://', repositoryPath pathString, '/src';
	     load
]
