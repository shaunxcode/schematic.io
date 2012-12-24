window.vendorRequire = (f) -> require "../vendor/#{f}.js"
window.dataRequire = (f) -> require "./data/#{f}.js"
window.appRequire = (f) -> require "./#{f}.js"
window.$ = window.jQuery = require "jquery"
window._ = require "underscore"
window.Backbone = vendorRequire "backbone"
window.Backbone.$ = $

vendorRequire "backbone.localStorage"
vendorRequire "jquery.splitter"

MaterialsCollection = dataRequire "Material/Collection"
MaterialModel = dataRequire "Material/Model"
LayersCollection = dataRequire "Layers/Collection"
SettingsModel = dataRequire "Settings/Model"

LayersView = appRequire "Layers/View"
PaletteView = appRequire "Palette/View"
LayerStackView = appRequire "LayerStack/View"
ConsoleView = appRequire "Console/View"
PreviewView = appRequire "Preview/View"
HUDView = appRequire "HUD/View"

App =
	init: ->
		$ => 
			$(window).on "resize", ->
				$vspliter.trigger "spliter.resize"
				$hspliter.trigger "spliter.resize"

			$(window).on "spliter.resize", -> Backbone.trigger "AppResized"

			$vspliter = $("#center").split orientation:"horizontal", position: "77%"
			$hspliter = $("#panels").split orientation:"vertical", position: "50%"

			size = 16

			settings = new SettingsModel
				width: size
				height: size
				size: size
				cellSize: 15
				color: {hex: "00ff00"}

			layersCollection = new LayersCollection

			@palette = new PaletteView
				el: $(".palette")
				settings: settings

			@palette.render()

			@layers = new LayersView
				el: $(".layers")
				settings: settings
				collection: layersCollection
			@layers.render()     

			@layerStack = new LayerStackView
				el: $(".layerStack")
				collection: layersCollection
				settings: settings

			@preview = new PreviewView
				el: $(".canvasHolder")
				settings: settings
				collection: layersCollection
			@preview.render()

			layersCollection.add show: true, name: "layer 1", y: 0

			@HUD = new HUDView
				el: $(".HUD")
				settings: settings
			@HUD.render()

			$layerStackHolder = $(".layerStackHolder")
			Backbone.on AppResized: =>
				@layerStack.$el.css height: $layerStackHolder.height() - @HUD.$el.height()

			Backbone.trigger "AppResized"
			
window.App = App
module.exports = App