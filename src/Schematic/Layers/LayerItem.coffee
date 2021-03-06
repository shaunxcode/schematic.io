downArrow = "&#x25BC;"
rightArrow = "&#x25B6;"

ArtifactsView = require "./Artifacts/View"

class LayerItem extends Backbone.View
    tagName: "li"
    events:
        "mouseenter": "showButtons"
        "mouseleave": "hideButtons"
        "click .remove": "remove"
        "click .show": "showOrHide"
        "click .duplicate": "duplicate"
        "click": "makeActive"
        "click .expansionToggle": "toggleExpansion"
        
    render: ->
        @artifacts = new ArtifactsView collection: @model.artifacts 
        @$el.text @model.get "name"
        @$el.prepend @$expansionToggle = $("<span />").addClass("expansionToggle").html rightArrow
        @$el.prepend @$show = $("<button />").addClass "show"
        @$el.append(
            $("<div />").addClass("buttons").append(
                @$duplicate = $("<button />").addClass "duplicate"
                @$remove = $("<button />").addClass "remove")
            @artifacts.render().$el)

        @$el.on
        @hideButtons()
        @isExpanded = false
        @artifacts.collapse()

        this
    
    hideButtons: ->
        @$("button.duplicate, button.remove").css visibility: "hidden"

    toggleExpansion: ->
        if @isExpanded
            @$expansionToggle.html rightArrow
            @isExpanded = false
            @artifacts.collapse()
        else
            @$expansionToggle.html downArrow
            @isExpanded = true
            @artifacts.expand()

    showButtons: ->
        @$("button").css visibility: "visible"

    makeActive: ->
        @model.trigger "makeActive"
        @$el.siblings().removeClass("active")
        @$el.addClass "active"
        
    duplicate: (e) ->
        console.log @model
        console.log "duplicate"

    showOrHide: (e) ->
        e.stopPropagation()
        if @model.get "show"
            @model.set show: false
            @$show.addClass "hidden"
            Backbone.trigger "preview:hideLayer", @model.get "y"
        else
            @model.set show: true
            @$show.removeClass "hidden"
            Backbone.trigger "preview:showLayer", @model.get "y"
            
    remove: ->
        super()
        Backbone.trigger "preview:removeLayer", @model.get "y"
        @model.trigger "remove"

        
module.exports = LayerItem