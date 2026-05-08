| swSystem adaptiveSolver pipe |

swSystem := WSSoftwareSystem 
	createForClass: RSShape
	usingStrategy: WSHierarchyClassCollector new.

adaptiveSolver := 
	WSAdaptive2DGridSolver 
		withTopology: WS2DRectangularGridTopology 
		andSwSystem: swSystem.
	
adaptiveSolver run.

pipe := '/Users/Simo/Desktop/Wassis/script/signal' asFileReference.
pipe writeStreamDo: [ :stream | 
	stream nextPutAll: LibC uniqueInstance getpid asString; lf ].

(Delay forSeconds: 5) wait.
Smalltalk snapshot: true andQuit: true.