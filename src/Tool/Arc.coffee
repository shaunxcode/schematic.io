{line, arc} = appRequire "Geometry"
Kinetic = vendorRequire "kinetic"

class Arc extends require("./Tool")
	first: (pos) ->
		@p1 = pos
		@_marks = []

	next: (pos) ->
		@p2 = pos
		@draw()

	last: ->
		@model.set p1: @p1, p2: @p2
		if @p3 then @model.set p3: @p3
		@layer.setCells @_marks
		@trigger "done"
		@editLayer?.remove()
		App.HUD.clear()

	abort: ->
		@last()
		
	draw: ->
		@layer.clearCells @_marks
		if @p3
			@_marks = arc @p1, @p3, @p2
		else
			@_marks = line @p1, @p2

		@layer.drawCells @_marks


	edit: ->
		@_ogp1 = @model.get "p1"
		@_ogp2 = @model.get "p2"
		@_ogp3 = @model.get "p3"

		@p1 = @model.get "p1"
		@p2 = @model.get "p2"
		@p3 = @model.get "p3"

		if @p3
			@_marks = arc @p1, @p3, @p2
		else
			@_marks = line @p1, @p2

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

		p3handle = new Kinetic.Circle
			x: 0
			y: 0
			radius: 5
			fill: "black"
			stroke: "black"
			draggable: true
			dragBoundFunc: (pos) =>
				if pos.x < p1x
					pos.x = p1x

				if pos.x > p2x 
					pos.x = p2x

				if pos.y > p2z
					pos.y = p2z

				pos 

		prect = new Kinetic.Rect
			x: 0 
			y: 0
			width: 0
			height: 0
			stroke: "black"

		p1x = p1z = p2x = p2z = 0

		setupControls = =>
			p1x = gridToPx @p1.x
			p1z = gridToPx @p1.z
			p2x = gridToPx @p2.x
			p2z = gridToPx @p2.z

			p1handle.setPosition p1x, p1z
			p2handle.setPosition p2x, p2z

			if not @p3
				p3handle.hide()
			else
				p3x = gridToPx @p3.x
				p3z = gridToPx @p3.z
				p3handle.setPosition p3x, p3z
				p3handle.show()

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

		p3handle.on "dragstart", (e) ->
			dragging = true
			dragPoint = 2

		@editLayer.on "mousemove", (e) =>
			if dragging
				@["p#{dragPoint+1}"] = @layer.eventPos e
				@draw()
				setupControls()

		@editLayer.on "mousedown", (e) =>
			return if @p3

			pos = @layer.eventPos e
			return if (pos.x is @p1.x and pos.z is @p1.z) or (pos.x is @p2.x and pos.z is @p2.z)
			@p3 = pos
			@draw()
			setupControls()
			

		p1handle.on "dragend", (e) ->
			setupControls()
			dragging = false

		p2handle.on "dragend", (e) ->
			setupControls()
			dragging = false

		p3handle.on "dragend", (e) ->
			setupControls()
			dragging = false

		layer.add prect
		layer.add p1handle
		layer.add p2handle
		layer.add p3handle
		stage.add layer


module.exports = Arc