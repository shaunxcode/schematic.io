class Collection extends Backbone.Collection
	model: require "./Model"
	localStorage: new Backbone.LocalStorage "ArtifactCollection"

module.exports = Collection