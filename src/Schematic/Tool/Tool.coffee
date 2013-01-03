class Tool extends Backbone.View
	initialize: ->
		@layer = @options.layer

	key: (pos) ->
		"#{pos.x}x#{pos.z}"

module.exports = Tool