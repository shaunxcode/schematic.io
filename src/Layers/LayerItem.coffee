downArrow = "&#x25BC;"
rightArrow = "&#x25B6;"

class LayerItem extends Backbone.View
    tagName: "li"
    events:
        "mouseout": "hideButtons"
        "mouseenter": "showButtons"
        "mouseenter .buttons": "cancelHideButtons"
        "mouseout .buttons": "cancelHideButtons"
        "click .remove": "remove"
        "click .show": "showOrHide"
        "click .duplicate": "duplicate"
        "click": "makeActive"
        "click .expansionToggle": "toggleExpansion"
        
    render: ->
        @$el.text @model.get "name"
        @$el.prepend @$expansionToggle = $("<span />").addClass("expansionToggle").html rightArrow
        @$el.append $("<div />").addClass("buttons").append(
            @$show = $("<button />").text("h").addClass "show"
            @$duplicate = $("<button />").text("d").addClass "duplicate"
            @$remove = $("<button />").text("x").addClass "remove")
        @hideButtons()
        @isExpanded = false
        this
    
    hideButtons: ->
        @hideTimeout = setTimeout (=> @$("button").css visibility: "hidden"), 50

    cancelHideButtons: (e) ->
        e.stopPropagation()
        clearTimeout @hideTimeout

    toggleExpansion: ->
        if @isExpanded
            @$expansionToggle.html rightArrow
            @isExpanded = false
        else
            @$expansionToggle.html downArrow
            @isExpanded = true

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
        @model.trigger "remove"
        
module.exports = LayerItem