class View extends Backbone.View
    events: 
        "click": "select"
        
    initialize: ->
        @settings = @options.settings
        
    select: ->
        @settings.set color: @model
        @$el.siblings().removeClass "active"
        @$el.addClass "active"
        
    render: ->
        @$el.css backgroundColor: @model.get "color"
        this
                
module.exports = View