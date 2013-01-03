vendorRequire "backbone.localStorage"
vendorRequire "jquery.splitter"

SchematicCollection = dataRequire "Schematic/Collection"
SchematicModel = dataRequire "Schematic/Model"
SettingsModel = dataRequire "Settings/Model"

PaletteView = require "./Palette/View"
EditorView = require "./Editor/View"
PreviewView = require "./Preview/View"
LayersView = require "./Layers/View"
ConsoleView = require "./Console/View"

class View extends Backbone.View

	initialize: ->
		@settings = @options.settings

		$vspliter = $("#center").split orientation:"horizontal", position: "90%", limit: 0
		$hspliter = $("#panels").split orientation:"vertical", position: "50%"

		$(window).on "resize", ->
				$vspliter.trigger "spliter.resize"
				$hspliter.trigger "spliter.resize"

			$(window).on "spliter.resize", -> Backbone.trigger "AppResized"

		@render()

	hide: ->
		@$el.hide()

	show: ->
		@$el.show()

	render: ->
			size = 16

			settings = new SettingsModel
				width: size
				height: size
				size: size
				cellSize: 15
				color: {hex: "5f5546"}

			schematicCollection = new SchematicCollection 

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


module.exports = View