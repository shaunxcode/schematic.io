LayerItem = require "./LayerItem"

class View extends Backbone.View
    events:
        "click button.newLayer": "newLayer"
        "keyup .width": "updateWidth"
        "keyup .height": "updateHeight"
        "keyup .size": "updateSize"
        "change .Schematics": "changeSchematic"

    initialize: ->
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

    addSchematicOption: (schematic) ->
        @$schematics.append $("<option />")
            .prop(value: schematic.get("urlId"))
            .text(schematic.get("name") + " " + schematic.get("urlId"))

    addAllSchematicOptions: ->
        @addSchematicOption schematic for schematic in App.schematics.models

    changeSchematic: ->
        @settings.setSchematicById @$schematics.val()

    render: ->
        @$ul = @$ "ul"
        @$width = @$(".width").val @settings.get "width"
        @$height = @$(".height").val @settings.get "height"
        @$size = @$(".size").val @settings.get "size"
        @$schematics = $(".Schematics")
        @listenTo App.schematics, "add", @addSchematicOption
        @addAllSchematicOptions()

        @listenTo @settings, "change:schematic", (c, schematic) ->
            @$schematics.val schematic.get "urlId"
            
        this

module.exports = View