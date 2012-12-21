class LayerItem extends Backbone.View
    tagName: "li"
    events:
        "click .remove": "remove"
        "click .show": "showOrHide"
        "click": "makeActive"
        
    render: ->
        @$el.text @model.get "name"
        @$el.prepend @$show = $("<button />").text("hide").addClass "show"
        @$el.append $("<button />").text("x").addClass "remove"
        this
    
    makeActive: ->
        @model.trigger "makeActive"
        @$el.siblings().removeClass("active")
        @$el.addClass "active"
        
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