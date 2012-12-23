class Pencil extends require("./Tool")
	first: (pos) ->
		@_marks = []

	next: (pos) ->
		@_marks.push pos
		@layer.drawCell pos

	last: (pos) ->
		@_marks.push pos
		@done()

	done: ->
		@layer.setCells @_marks
		@model.set points: @_marks
		@trigger "done"

	abort: ->
		@done()


module.exports = Pencil