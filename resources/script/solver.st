| swSystem adaptiveSolver |

swSystem := WSSoftwareSystem 
	usingStrategy: 
		(WSFullHierarchyCollector withOriginClass: InstructionClient).

adaptiveSolver := 
	WSAdaptive2DGridSolver 
		withTopology: WS2DRectangularGridTopology 
		andSwSystem: swSystem.
	
adaptiveSolver run.

Smalltalk snapshot: false andQuit: true.