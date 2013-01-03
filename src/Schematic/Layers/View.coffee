LayerItem = require "./LayerItem"

class View extends Backbone.View
    events:
        "click button.newLayer": "newLayer"
        "keyup .width": "updateWidth"
        "keyup .height": "updateHeight"
        "keyup .size": "updateSize"
        
    initialize: ->
        @settings = @options.settings
        @children = []

        #@listenTo @collection, "add", @addLayer
        @listenTo Backbone, "artifact:doneEditing", => 
            @$(".artifact").removeClass("active")

    newLayer: ->
        @collection.add
            show: true
            name: "layer #{@children.length + 1}"
            y: @children.length

    addLayer: (layer) ->
        child = new LayerItem model: layer
        @children.push child
        @$ul.prepend child.render().$el
        child.makeActive()
        
    updateWidth: ->
        @settings.set "width", @$width.val()
        
    updateHeight: ->
        @settings.set "height", @$height.val()
        
    updateSize: ->
        @settings.set "size", @$size.val()
        
    render: ->
        @$ul = @$ "ul"
        @$width = @$(".width").val @settings.get "width"
        @$height = @$(".height").val @settings.get "height"
        @$size = @$(".size").val @settings.get "size"
        this

module.exports = View