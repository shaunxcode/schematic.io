class Tool extends Backbone.View
	initialize: ->
		@layer = @options.layer
		@color = @options.color

	key: (pos) ->
		"#{pos.x}x#{pos.z}"

module.exports = Tool