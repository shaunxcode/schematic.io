window.vendorRequire = (f) -> require "../vendor/#{f}.js"
window.dataRequire = (f) -> require "./data/#{f}.js"
window.appRequire = (f) -> require "./#{f}.js"
window.$ = window.jQuery = require "jquery"
window._ = require "underscore"
window.Backbone = vendorRequire "backbone"
vendorRequire "bootstrap/bootstrap"
vendorRequire "backbone.localStorage"
window.Backbone.$ = $
SchematicView = require "./Schematic/View"
SchematicCollection = dataRequire "Schematic/Collection"
SchematicModel = dataRequire "Schematic/Model"

class Router extends Backbone.Router
	routes:
		"": "home"
		"about": "about" 
		"search": "search"
		"signupin": "signupin"
		"schematic/new": "newSchematic"
		"schematic/*path": "schematic"

	initialize: ->
		@viewEls = 
			home: $("#home")
			about: $("#about")
			search: $("#search")
			schematic: (new SchematicView el: $("#schematic"), collection: App.schematics)
			signupin: $("#signupin")
		
		$(document).on "click", "a[href^='/']", (event) =>
			if !event.altKey and !event.ctrlKey and !event.metaKey and !event.shiftKey
				event.preventDefault()
				@navigate $(event.currentTarget).attr("href"), trigger: true

	show: (viewName) ->
		el.hide() for name, el of @viewEls
		@viewEls[viewName].show()
		
	home: ->
		@show "home"

	about: ->
		@show "about"

	search: ->
		@show "search"

	signupin: ->
		@show "signupin"

	newSchematic: ->
		s = App.schematics.create name: "new schematic"
		@navigate "/schematic/#{s.get "urlId"}", trigger: true, replace: true

	schematic: (path) ->
		console.log "load", path
		@show "schematic"

			

App =
	init: ->
		$ =>
			@schematics = new SchematicCollection
			@schematics.fetch()
			
			router = new Router
			Backbone.history.start pushState: true
			Backbone.trigger "AppResized"


window.App = App
module.exports = App