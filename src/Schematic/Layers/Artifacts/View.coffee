ArtifactItem = require "./ArtifactItem"
downArrow = "&#x25BC;"
rightArrow = "&#x25B6;"

class View extends Backbone.View
	className: "Artifacts"
		

	add: (artifactModel) -> 
		if not @tools[artifactModel.get "tool"]
			@$tree.append $("<li />")
				.text(artifactModel.get "tool")
				.prepend($expansionToggle = $("<span />").addClass("arrow").html downArrow)
				.append(
					@tools[artifactModel.get "tool"] = $ul = $("<ul />").addClass(artifactModel.get "tool"))

			expanded = true
			$expansionToggle.on click: ->
				if expanded
					$ul.css height: 0
					expanded = false
					$expansionToggle.html rightArrow
				else
					$ul.css height: "auto"
					expanded = true
					$expansionToggle.html downArrow

		@tools[artifactModel.get "tool"].append (new ArtifactItem model: artifactModel).render().$el

		this

	render: ->
		@tools = {}
		@$el.append @$tree = $("<ul />")

		@listenTo @collection, "add", @add

		this

	collapse: ->
		@$el.css height: 0

	expand: ->
		@$el.css height: "auto"

module.exports = View