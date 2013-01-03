{rect, circle} = appRequire "Geometry"
Kinetic = vendorRequire "kinetic"

class Circle extends require("./Tool")
	first: (pos) ->
		@p1 = pos
		@_marks = []

	next: (pos) ->
		@p2 = pos
		@draw()

	last: ->
		@model.set p1: @p1, p2: @p2
		@layer.setCells @_marks
		@trigger "done"
		@editLayer?.remove()
		App.HUD.clear()

	abort: ->
		@last()
		
	draw: ->
		@layer.clearCells @_marks
		@_marks = circle @p1, Math.abs @p2.x - @p1.x
		@layer.drawCells @_marks


	points: ->
		circle @model.get("p1"), Math.abs @model.get("p2").x - @model.get("p1").x

	edit: ->
		@_ogp1 = @model.get "p1"
		@_ogp2 = @model.get "p2"

		@p1 = @model.get "p1"
		@p2 = @model.get "p2"
		@_marks = circle @p1, Math.abs @p2.x - @p1.x
		@layer.clearMarks @_marks
		@draw()

		size = @layer.cellSize
		sizeHalf = size / 2
		width = @layer.width

		@layer.$el.append @editLayer = $("<div />").addClass("tool")

		App.HUD
			.clear()
			.button(OK: => @last())
			.button(Cancel: => 
				@p1 = @_ogp1
				@p2 = @_ogp2
				@draw()
				@last())

		gridToPx = (v) ->
			((v + width) * size) + sizeHalf

		stage = new Kinetic.Stage
			container: @editLayer[0]
			width: @layer._props.width
			height: @layer._props.height

		layer = new Kinetic.Layer()

		p1handle = new Kinetic.Circle
			x: 0
			y: 0
			radius: 5
			fill: "black"
			stroke: "black"
			draggable: true

		p2handle = new Kinetic.Circle
			x: 0
			y: 0
			radius: 5
			fill: "black"
			stroke: "black"
			draggable: true


		prect = new Kinetic.Rect
			x: 0 
			y: 0
			width: 0
			height: 0
			stroke: "black"

		setupControls = =>
			p1x = gridToPx @p1.x
			p1z = gridToPx @p1.z
			p2x = gridToPx @p2.x
			p2z = gridToPx @p2.z

			p1handle.setPosition p1x, p1z
			p2handle.setPosition p2x, p2z

			prect.setPosition p1x, p1z
			prect.setWidth p2x - p1x
			prect.setHeight p2z - p1z

			layer.draw()

		setupControls()

		dragging = false
		dragPoint = 0

		p1handle.on "dragstart", (e) ->
			dragging = true
			dragPoint = 0

		p2handle.on "dragstart", (e) ->
			dragging = true
			dragPoint = 1

		@editLayer.on "mousemove", (e) =>
			if dragging
				
				@["p#{dragPoint+1}"] = @layer.eventPos e
				@draw()

				setupControls()

		p1handle.on "dragend", (e) ->
			setupControls()
			dragging = false

		p2handle.on "dragend", (e) ->
			setupControls()
			dragging = false


		layer.add prect
		layer.add p1handle
		layer.add p2handle
		stage.add layer


module.exports = Circle