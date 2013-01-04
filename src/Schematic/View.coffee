vendorRequire "backbone.localStorage"
vendorRequire "jquery.splitter"

SettingsModel = dataRequire "Settings/Model"
PaletteView = require "./Palette/View"
EditorView = require "./Editor/View"
PreviewView = require "./Preview/View"
LayersView = require "./Layers/View"
ConsoleView = require "./Console/View"

class View extends Backbone.View

	initialize: ->
		@settings = @options.settings

		@render()

	hide: ->
		@$el.hide()

	show: ->
		@$el.show()
		$(window).trigger "resize"

	render: ->
		size = 16

		settings = new SettingsModel
			width: size
			height: size
			size: size
			cellSize: 15
			color: {hex: "5f5546"}

		@palette = new PaletteView
			el: $(".palette")
			settings: settings
		@palette.render()

		@editor = new EditorView
			el: $(".editor")
			settings: settings

		@preview = new PreviewView
			el: $(".preview")
			settings: settings
		@preview.render()
		
		@layers = new LayersView
			el: $(".layers")
			settings: settings
		@layers.render()

		@console = new ConsoleView 
			el: $(".console")
			settings: settings
		@console.render()

		@$el.show()
		$vspliter = $("#center").split orientation:"horizontal", position: "80%", limit: 0
		$hspliter = $("#panels").split orientation:"vertical", position: "50%"

		$(window).on "resize", ->
			$vspliter.trigger "spliter.resize"
			$hspliter.trigger "spliter.resize"

		$(window).on "spliter.resize", -> Backbone.trigger "AppResized"

		@$el.hide()


module.exports = View