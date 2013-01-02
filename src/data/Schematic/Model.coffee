LayersCollection = require "./Layer/Collection"

class Model extends Backbone.Model
	defaults:
		name: ""
		description: ""
		keywords: []

	initialize: ->
		@layers = new LayersCollection


module.exports = Model