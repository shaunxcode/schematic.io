downArrow = "&#x25BC;"
rightArrow = "&#x25B6;"

ArtifactsView = require "./Artifacts/View"

class LayerItem extends Backbone.View
    tagName: "li"
    events:
        "mouseout": "hideButtons"
        "mouseenter": "showButtons"
        "mouseenter span": "cancelHideButtons"
        "mouseenter .buttons": "cancelHideButtons"
        "mouseout .buttons": "cancelHideButtons"
        "click .remove": "remove"
        "click .show": "showOrHide"
        "click .duplicate": "duplicate"
        "click": "makeActive"
        "click .expansionToggle": "toggleExpansion"
        
    render: ->
        @artifacts = new ArtifactsView collection: @model.artifacts 
        @$el.text @model.get "name"
        @$el.prepend @$expansionToggle = $("<span />").addClass("expansionToggle").html rightArrow
        @$el.append(
            $("<div />").addClass("buttons").append(
                @$show = $("<button />").text("h").addClass "show"
                @$duplicate = $("<button />").text("d").addClass "duplicate"
                @$remove = $("<button />").text("x").addClass "remove")
            @artifacts.render().$el)

        @hideButtons()
        @isExpanded = false
        @artifacts.collapse()
        this
    
    hideButtons: ->
        @hideTimeout = setTimeout (=> @$("button").css visibility: "hidden"), 10

    cancelHideButtons: (e) ->
        e.stopPropagation()
        clearTimeout @hideTimeout

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
        console.log "duplicate"

    showOrHide: (e) ->
        if @model.get "show"
            @model.set show: false
            @$show.text "show"
        else
            @model.set show: true
            @$show.text "hide"
            
    remove: ->
        super()
        Backbone.trigger "preview:removeLayer", @model.get "y"
        @model.trigger "remove"

        
module.exports = LayerItem