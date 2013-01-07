vendorRequire "backbone.localStorage"
vendorRequire "jquery.splitter"

PaletteView = require "./Palette/View"
EditorView = require "./Editor/View"
PreviewView = require "./Preview/View"
LayersView = require "./Layers/View"
ConsoleView = require "./Console/View"

class View extends Backbone.View

	hide: ->
		@$el.hide()

	show: ->
		@$el.show()
		$(window).trigger "resize"

	render: ->
		@palette = new PaletteView
			el: $(".palette")
			settings: @settings
		@palette.render()

		@editor = new EditorView
			el: $(".editor")
			settings: @settings
		@editor.render()

		@preview = new PreviewView
			el: $(".preview")
			settings: @settings
		@preview.render()
		
		@layers = new LayersView
			el: $(".layers")
			settings: @settings
		@layers.render()

		@console = new ConsoleView 
			el: $(".console")
			settings: @settings
		@console.render()

		@$el.show()
		@$vspliter = $("#center").split orientation:"horizontal", position: "80%", limit: 0
		@$hspliter = $("#panels").split orientation:"vertical", position: "50%", limit: 0

		$(window).on "resize", =>
			@$vspliter.trigger "spliter.resize"
			@sizePanels()

		$(window).on "spliter.resize", -> Backbone.trigger "AppResized"

		@$el.hide()

		@listenTo @settings, "change:schematic", -> 
			console.log "CHANGE SCHEMATIC", @settings.get "schematic"
		
		@$leftPane = $(".left_panel", @$hspliter)
		@$rightPane = $(".right_panel", @$hspliter)
		@$vsplitter = $(".vspliter", @$hspliter)

		@$schematicPanelsToggle = $("#schematicPanelsToggle").ouija().change => @sizePanels()

		this
	
	sizePanels: ->
		switch @$schematicPanelsToggle.val() 
			when "2D"
				@$rightPane.css width: 0
				@$leftPane.css width: @$hspliter.width() - @$vsplitter.width()
				@$vsplitter.css left: @$hspliter.width() - @$vsplitter.width()

			when "3D"
				@$leftPane.css width: 0
				@$rightPane.css width: @$hspliter.width() - @$vsplitter.width()
				@$vsplitter.css left: 0

			when "Both"
				w = (@$hspliter.width() - @$vsplitter.width()) / 2
				@$leftPane.css width: w
				@$rightPane.css width: w
				@$vsplitter.css left: w
		
		Backbone.trigger "AppResized"

module.exports = View