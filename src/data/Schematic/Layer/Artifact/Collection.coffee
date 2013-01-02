class Collection extends Backbone.Collection
	model: require "./Model"
	localStorage: new Backbone.LocalStorage "ArtifactCollectionn"

module.exports = Collection