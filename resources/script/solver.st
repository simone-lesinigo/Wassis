| swSystem adaptiveSolver |

"swSystem := WSSoftwareSystem 
	usingStrategy: 
		(WSFullHierarchyCollector withOriginClass: InstructionClient)."

swSystem := WSSoftwareSystem 
	usingStrategy: 
		(WSJavaCollector 
			jsonFile: 'jetuml.json' 
			forPackage: 'org.jetuml.diagram'     
			using: { 
				[ :cls | cls superclass ] -> WSRelationType inheritance.
				[ :cls | cls outgoingRelationships select: #isJavaFieldReadEdge thenCollect: [ :e | e target parent ] ] -> WSRelationType usage
			}).

adaptiveSolver := 
	WSAdaptive2DGridSolver 
		withTopology: WS2DRectangularGridTopology 
		andSwSystem: swSystem.
	
adaptiveSolver run.

Smalltalk snapshot: false andQuit: true.