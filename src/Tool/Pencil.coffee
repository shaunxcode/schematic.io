class Pencil extends require("./Tool")
	first: (pos) ->
		@_marks = []
		@_seen = {}

	next: (pos) ->
		return if @_seen[@key pos]

		@_seen[@key pos] = true
		@_marks.push pos
		@layer.drawCell pos

	last: (pos) ->
		if not @_seen[@key pos]
			@_marks.push pos

		@done()

	done: ->
		@layer.setCells @_marks
		@model.set points: @_marks
		@trigger "done"

	points: ->
		@model.get "points"
		
	abort: ->
		@done()


module.exports = Pencil