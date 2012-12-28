class ArtifactItem extends Backbone.View
	tagName: "li"
	className: "artifact"

	events: 
		"click": "edit"
		"click .show": "showOrHide"

	render: ->
		@$el.text "artifact"
		@$el.prepend @$show = $("<button />").addClass "show"
		@$el.append @$remove = $("<button />").addClass "remove"
		this
	
	showOrHide: (e) ->
		e.stopPropagation()
		if @model.get "show"
			@model.set show: false
			@$show.addClass "hidden"
			Backbone.trigger "artifact:#{@model.get "layer"}:hide", @model
		else
			@model.set show: true
			@$show.removeClass "hidden"
			Backbone.trigger "artifact:#{@model.get "layer"}:show", @model

	edit: ->
		Backbone.trigger "artifact:#{@model.get "layer"}:edit", @model

		$(".artifact").removeClass "active"
		@$el.addClass "active"



module.exports = ArtifactItem