{point, line} = appRequire "Geometry"

class Line extends require("./Tool")
	first: (pos) ->
		@p1 = pos
		@_marks = []

	next: (pos) ->
		@p2 = pos
		
		@layer.clearCells @_marks

		@_marks = line @p1, @p2

		@layer.drawCells @_marks

	last: ->
		@layer.setCells @_marks
		@trigger "done"

	abort: ->
		@last()
		
module.exports = Line