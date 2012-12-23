tools = 
    pencil: appRequire "Tool/Pencil"
    line: appRequire "Tool/Line"

key = (pos) -> "#{pos.x}x#{pos.z}"

special = 
    marquee: ->
    eraser: ->
    bucket: ->

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

        tool = @settings.get "tool"

        if special[tool] 
            return

        if tools[tool]
            @tool = new tools[tool] 
                model: @model.artifacts.create {tool} 
                layer: @
                color: @settings.get "color"

            
            @listenTo @tool, "done", =>
                @tool.remove()
                delete @tool

            @tool.first $(event.currentTarget).data()
            @draw event
    
    draw: (event) ->
        return if not @tool
        @tool.next $(event.currentTarget).data()
        
    stopDraw: (event) ->
        if @tool
            if event
                @tool.last $(event.currentTarget).data()
            else
                @tool.abort()

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
        
    drawCell: (pos) ->
        color = @settings.get "color"
        @cells[key pos].css background: color.get "color"
        pos.y = @model.get "y"
        Backbone.trigger "preview:addBlock", {pos, color: color.get "hex"}

    clearCell: (pos) ->
        color = @model.get key pos
        
        Backbone.trigger "preview:clearBlock", {pos}
        if not color
            @cells[key pos].css background: "inherit"
        else
            @cells[key pos].css background: color.get "color"
            Backbone.trigger "preview.addBlock", {pos, color: color.get "hex"}

    drawCells: (cells) ->
        @drawCell cell for cell in cells

    clearCells: (cells) ->
        @clearCell cell for cell in cells

    setCells: (cells) ->
        for cell in cells 
            @model.set key(cell), @settings.get("color")

    drawGrid: ->
        @cells = {}
        @$el.html tbody = $("<tbody />")
        cellSize = @settings.get "cellSize"
        y = @model.get "y"
        height = @settings.get "height"
        width = @settings.get "width"
        for z in [-height..height-1]
            tbody.append row = $("<tr />")
            for x in [-width..width-1]
                row.append @cells["#{x}x#{z}"] = td = $("<td />")
                    .addClass("#{x}x#{z}")
                    .html($("<div />").css width: cellSize, height: cellSize)
                    .data({x, z, y})

                if color = @model.get "#{x}x#{z}"
                    td.css backgroundColor: color.get("color")
        
module.exports = View