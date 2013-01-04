window.vendorRequire = (f) -> require "../vendor/#{f}.js"
window.dataRequire = (f) -> require "./data/#{f}.js"
window.appRequire = (f) -> require "./#{f}.js"
window.$ = window.jQuery = require "jquery"
window._ = require "underscore"
window.Backbone = vendorRequire "backbone"
vendorRequire "bootstrap/bootstrap"
window.Backbone.$ = $
SchematicView = require "./Schematic/View"

class Router extends Backbone.Router
	routes:
		"": "home"
		"about": "about" 
		"search": "search"
		"signupin": "signupin"
		"schematic/*path": "schematic"

	initialize: ->
		@viewEls = 
			home: $("#home")
			about: $("#about")
			search: $("#search")
			schematic: (new SchematicView el: $("#schematic"))
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

	schematic: ->
		@show "schematic"
		

App =
	init: ->
		$ =>
			router = new Router
			Backbone.history.start pushState: true
			Backbone.trigger "AppResized"

window.App = App
module.exports = App