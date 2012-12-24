class ArtifactItem extends Backbone.View
	tagName: "li"
	className: "artifact"

	events: 
		"click": "edit"

	render: ->
		@$el.text "artifact"
		this
	
	edit: ->
		Backbone.trigger "artifact:#{@model.get "layer"}:edit", @model

		$(".artifact").removeClass "active"
		@$el.addClass "active"



module.exports = ArtifactItem