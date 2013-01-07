Kinetic = vendorRequire "kinetic"

class View extends Backbone.View
	events: 
		"mousemove canvas": "draw"

	initialize: ->
		@listenTo @settings, "change:schematic", (c, m) -> 
			console.log "schematic", m

		@cellSize = @settings.get "cellSize"
		@width = @settings.get "width"
		@height = @settings.get "height"

		#we multiply the "blocks" by the individual cell width and then double it as we have a polar coord system e.g. 
		# [1][2]
		# [3][4]
		#with (0,0) being in the center

		@displayWidth = @width * @cellSize * 2
		@displayHeight = @height * @cellSize * 2

		console.log @displayWidth, @displayHeight

	eventPos: (event) ->    
        x: (Math.floor event.offsetX / @cellSize) - @width
        z: (Math.floor event.offsetY / @cellSize) - @height

	draw: (event) ->
		console.log @eventPos event

	render: ->
		#@$el.append $("<div />").addClass("layerSlider").css(zIndex: 200000, marginTop: 20).slider()
		@$el.html @$canvasHolder = $("<div />")
		
		@stage = new Kinetic.Stage
			container: @$canvasHolder[0]
			width: @displayWidth
			height: @displayHeight

		@stage.add layer for layer in @layers = [
			new Kinetic.Layer
			new Kinetic.Layer
			new Kinetic.Layer
			new Kinetic.Layer
			@grid = new Kinetic.Layer
		]

		@listenTo Backbone, "AppResized", @positionGrid
		
		@drawLayers()
		@positionGrid()

	drawLayers: ->

		#draw top 5 layers starting at current and going back by 5 - only draw grid lines on the tippity top layer
		for layer, index in @layers
			#start from back and work way forward 
			layer.clear()

		#draw grid lines on last layer after everything else is drawn
		for x in [0..@displayWidth] by @cellSize
			@grid.add new Kinetic.Line
				points: [x - 0.5, 0, x - 0.5, @displayWidth]
				strokeWidth: 1
				stroke: "#ededed"
			for z in [0..@displayHeight] by @cellSize
				@grid.add new Kinetic.Line
					points: [0, z - 0.5, @displayHeight, z - 0.5]
					strokeWidth: 1
					stroke: "#ededed"
		
		@stage.draw()

	positionGrid: ->
		@$canvasHolder.css marginTop: (@$el.height() - @displayHeight) / 2

module.exports = View