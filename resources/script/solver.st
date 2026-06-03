| swSystem adaptiveSolver |

swSystem := WSSoftwareSystem 
	createForClass: RSEvent
	usingStrategy: WSHierarchyClassCollector new.

adaptiveSolver := 
	WSAdaptive2DGridSolver 
		withTopology: WS2DRectangularGridTopology 
		andSwSystem: swSystem.
	
adaptiveSolver run.

Smalltalk snapshot: false andQuit: true.