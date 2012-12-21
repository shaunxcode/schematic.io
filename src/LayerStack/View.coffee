SliceView = require "./SliceView"

class View extends Backbone.View
    events: 
        "mouseleave": "stopDrawing"
    
    stopDrawing: ->
        child.stopDraw() for child in @children
        
    initialize: ->
        @settings = @options.settings
        @children = []
        @listenTo @collection, "add", @addSlice
        
    addSlice: (layer) ->
        child = new SliceView model: layer, settings: @settings
        @children.push child
        @$el.append child.render().$el
        child.makeActive()
        
module.exports = View