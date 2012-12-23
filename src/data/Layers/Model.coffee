ArtifactsCollection = dataRequire "Artifact/Collection"

class Model extends Backbone.Model
	initialize: ->
		@artifacts = new ArtifactsCollection

module.exports = Model