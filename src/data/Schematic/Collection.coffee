class Collection extends Backbone.Collection
	model: require "./Model"
	localStorage: new Backbone.LocalStorage "Schematics"

module.exports = Collection