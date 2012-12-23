class Model extends Backbone.Model
	initialize: ->
		@_cancelled = true
		
	isCancelled: ->
		@_cancelled

module.exports = Model