class Model extends Backbone.Model
	initialize: ->
		@_cancelled = true
		
	isCancelled: ->
		@_cancelled

	getPoints: ->
		#cache tool instance
		if not @_tool
			tool = require "../../Tool/#{@get "tool"}"
			@_tool = new tool model: this

		@_tool.points()

module.exports = Model