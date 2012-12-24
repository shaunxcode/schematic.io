class View extends Backbone.View
	clear: ->
		@$el.html ""
		this

	button: (buttons) ->
		for button, cb of buttons
			@$el.append $("<button />").text(button).on click: cb

		this
		
	render: ->
		this

module.exports = View