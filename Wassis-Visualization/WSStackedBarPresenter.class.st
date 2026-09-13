Class {
	#name : 'WSStackedBarPresenter',
	#superclass : 'WSMetricPresenter',
	#instVars : [
		'canvasPresenter'
	],
	#category : 'Wassis-Visualization-Presenter',
	#package : 'Wassis-Visualization',
	#tag : 'Presenter'
}

{ #category : 'layout' }
WSStackedBarPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: canvasPresenter;
		  yourself
]

{ #category : 'initialization' }
WSStackedBarPresenter >> initializePresenters [

	canvasPresenter := self instantiate: SpRoassalPresenter.
]

{ #category : 'initialization' }
WSStackedBarPresenter >> updatePresenter [

	super updatePresenter.
	Metrics ifNil: [ ^ self ].

	canvasPresenter script: [ :canvas |
		| classCount pathCount emptyCount total barWidth barHeight barX y segments legendX legendY |
		canvas clearShapes.
		classCount := Metrics graphMetrics numberOfClassNodes.
		pathCount := Metrics graphMetrics numberOfPathNodes.
		emptyCount := Metrics graphMetrics numberOfEmptyNodes.
		total := (classCount + pathCount + emptyCount) max: 1.

		barWidth := 40.
		barHeight := 200.
		barX := -100.

		segments := {
			{ 'Class'. classCount. Color blue }.
			{ 'Path'. pathCount. Color green }.
			{ 'Empty '. emptyCount. Color red }
		}.

		y := (barHeight / 2) negated.
		segments do: [ :seg |
			| count color segHeight box |
			count := seg second.
			color := seg third.
			segHeight := count / total asFloat * barHeight.
			box := RSBox new
				width: barWidth;
				height: segHeight;
				color: color;
				position: barX @ (y + (segHeight / 2));
				yourself.
			canvas add: box.
			y := y + segHeight ].

		legendX := barX + barWidth + 20.
		legendY := (barHeight / 2) negated.
		segments do: [ :seg |
			| label count color swatch text |
			label := seg first.
			count := seg second.
			color := seg third.
			swatch := RSBox new
				width: 12;
				height: 12;
				color: color;
				position: legendX @ legendY;
				yourself.
			text := RSLabel new
				text: label , ': ' , count printString;
				position: legendX + 60 @ legendY;
				yourself.
			canvas add: swatch.
			canvas add: text.
			legendY := legendY + 20 ] ]
]
