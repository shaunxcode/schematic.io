window.vendorRequire = (f) -> require "../vendor/#{f}.js"
window.dataRequire = (f) -> require "./data/#{f}.js"
window.appRequire = (f) -> require "./#{f}.js"
window.$ = require "jquery"
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

App =
	init: ->
		$ => 
			$(window).on "resize", ->
				$vspliter.trigger "spliter.resize"
				$hspliter.trigger "spliter.resize"

			$(window).on "spliter.resize", -> Backbone.trigger "AppResized"

			$vspliter = $("#center").split orientation:"horizontal", position: "77%"
			$hspliter = $("#panels").split orientation:"vertical", position: "50%"

			size = 30

			settings = new SettingsModel
				width: size
				height: size
				size: size
				cellSize: 15

			materials = new MaterialsCollection [
				new MaterialModel name: "grass", color: "green", hex: 0x008800
				new MaterialModel name: "cobble", color: "grey", hex: 0x808080
				new MaterialModel name: "lapis", color: "blue", hex: 0x0000ff
			]
			    
			layersCollection = new LayersCollection

			@palette = new PaletteView
				el: $(".palette")
				collection: materials
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
				materials: materials
			@preview.render()

			layersCollection.add show: true, name: "layer 1", y: 0

window.App = App
module.exports = App