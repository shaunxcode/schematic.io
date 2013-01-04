LayersCollection = require "./Layer/Collection"
sgen = require "sgen"

class Model extends Backbone.Model
	defaults:
		name: ""
		description: ""
		keywords: []

	initialize: ->
		@layers = new LayersCollection
		if @isNew()
			@set urlId: sgen.random 12


module.exports = Model