{rect} = appRequire "Geometry"

class Square extends require("./Tool")
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
		@_marks = rect @p1, @p2
		@layer.drawCells @_marks

module.exports = Square