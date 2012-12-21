class View extends Backbone.View
    tagName: "table"
    events:
        "drag": "noop"
        "mousedown td": "startDraw"
        "mouseover td": "draw"
        "mouseup td": "stopDraw"
    
    noop: -> false
    
    startDraw: (event) ->
        event.stopPropagation()
        @drawing = true
        @draw event
    
    draw: (event) ->
        return if not @drawing
        
        cell = $(event.currentTarget)
        pos = cell.data()
        color = @settings.get("color").get "color"
        @model.set "#{pos.x}x#{pos.y}", color
        Backbone.trigger "addBlock", pos: {x: pos.x, z: pos.y, y: pos.z}, color: @settings.get("color").get "hex"
        cell.css backgroundColor: color
        
    stopDraw: ->
        @drawing = false
    
    initialize: ->
        @settings = @options.settings
        @listenTo @model, "remove", @remove
        @listenTo @model, "change:show", @toggleShow
        @listenTo @model, "makeActive", @makeActive
        @listenTo @settings, "change:width", @drawGrid
        @listenTo @settings, "change:height", @drawGrid
        @listenTo @settings, "change:size", @drawGrid
                        
    render: ->
        @drawGrid()
        this
        
    toggleShow: ->
        if @model.get "show"
            @$el.show()
        else
            @$el.hide()
        
    makeActive: ->
        @$el.siblings().css zIndex: 1
        @$el.css zIndex: 999
        
    drawGrid: ->
        @$el.html ""
        tbody = $("<tbody />")
        size = @settings.get "size"
        z = @model.get "z"
        height = @settings.get "height"
        width = @settings.get "width"
        for y in [-height..height-1]
            row = $("<tr />")
            for x in [-width..width-1]
                row.append td = $("<td />")
                    .html($("<div />").css width: size, height: size)
                    .data({x, y, z})
                    
                if color = @model.get "#{x}x#{y}"
                    td.css backgroundColor: color
                    
            tbody.append row
        @$el.append tbody
        
module.exports = View