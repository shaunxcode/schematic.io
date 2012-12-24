class ArtifactItem extends Backbone.View
	tagName: "li"
	className: "artifact"

	events: 
		"click": "edit"

	render: ->
		@$el.text "artifact"
		this
	
	edit: ->
		$(".artifact").removeClass "active"
		@$el.addClass "active"

		Backbone.trigger "artifact:edit", @model

module.exports = ArtifactItem