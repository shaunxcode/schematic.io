window.CodeMirror = require "code-mirror"
vendorRequire "code-mirror-clojure"

class View extends Backbone.View
	initialize: ->
		@listenTo Backbone, "AppResized", => 
			@$scrollingPanes.css height: @$el.innerHeight() - 78
			@mirror.setValue @mirror.getValue()

	render: ->
		@mirror = CodeMirror @$el[0], lineNumbers: true, theme: "twilight"

		@$scrollingPanes = @$ ".CodeMirror, .CodeMirror-scroll, .CodeMirror-scrollbar"
		@mirror.setValue "Console"

module.exports = View