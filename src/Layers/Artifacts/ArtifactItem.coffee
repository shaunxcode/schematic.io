class ArtifactItem extends Backbone.View
	tagName: "li"

	render: ->
		@$el.text "artifact"
		this
		
module.exports = ArtifactItem