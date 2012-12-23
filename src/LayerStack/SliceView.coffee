tools = 
    pencil: appRequire "Tool/Pencil"
    line: appRequire "Tool/Line"

key = (pos) -> "#{pos.x}x#{pos.z}"

special = 
    marquee: ->
    eraser: ->
    bucket: ->

class View extends Backbone.View
    tagName: "div"
    events:
        "mousewheel": "scale"
        "drag": "noop"
        "mousedown": "startDraw"
        "mousemove": "draw"
        "mouseup": "stopDraw"
    
    noop: -> false
    
    scale: (event) ->
        event.stopPropagation()
        
    eventPos: (event) ->    
        x: (Math.floor event.offsetX / @cellSize) - @width
        z: (Math.floor event.offsetY / @cellSize) - @height

    startDraw: (event) ->
        event.stopPropagation()

        tool = @settings.get "tool"

        if special[tool] 
            return

        if tools[tool]
            @tool = new tools[tool] 
                model: @model.artifacts.create {tool, color: @settings.get("color").get("color")} 
                layer: @
                color: @settings.get "color"

            
            @listenTo @tool, "done", =>
                @tool.remove()
                delete @tool

            @tool.first @eventPos event 
            @draw event
    
    draw: (event) ->
        return if not @tool
        @tool.next @eventPos event
        
    stopDraw: (event) ->
        if @tool
            if event
                @tool.last @eventPos event
            else
                @tool.abort()

    initialize: ->
        @settings = @options.settings
        @width = @settings.get "width"
        @height = @settings.get "height"
        @cellSize = @settings.get "cellSize"
        @listenTo @model, "remove", @remove
        @listenTo @model, "change:show", @toggleShow
        @listenTo @model, "makeActive", @makeActive
        @listenTo @settings, "change:width", @drawGrid
        @listenTo @settings, "change:height", @drawGrid
        @listenTo @settings, "change:size", @drawGrid
        
    render: ->
        _props =
            width: @width * @cellSize * 2
            height: @height * @cellSize * 2

        @$el.append(
            @$gridCanvas = $("<canvas />").addClass("grid").prop _props
            @$cellCanvas = $("<canvas />").addClass("cells").prop _props)

        @gridCtx = @$gridCanvas[0].getContext "2d"
        @cellCtx = @$cellCanvas[0].getContext "2d"
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

    _drawPos: (pos, color) ->
        if color is "inherit"
            method = "clearRect"
        else 
            method = "fillRect"
            @cellCtx.fillStyle = color

        @cellCtx[method] (pos.x + @width) * @cellSize, (pos.z + @height) * @cellSize, @cellSize - 0.5, @cellSize - 0.5
        this

    drawCell: (pos) ->
        color = @settings.get "color"
        @_drawPos pos, color.get "color"
        pos.y = @model.get "y"
        Backbone.trigger "preview:addBlock", {pos, color: color.get "hex"}

    clearCell: (pos) ->
        color = @model.get key pos
        
        Backbone.trigger "preview:clearBlock", {pos}
        if not color
            @_drawPos pos, "inherit"
        else
            @_drawPos pos, color.get "color"
            Backbone.trigger "preview.addBlock", {pos, color: color.get "hex"}

    drawCells: (cells) ->
        @drawCell cell for cell in cells

    clearCells: (cells) ->
        @clearCell cell for cell in cells

    setCells: (cells) ->
        for cell in cells 
            @model.set key(cell), @settings.get("color")

    drawGrid: ->
        @gridCtx.strokeStyle = "black"
        @gridCtx.lineWidth = 1
        cellSize = @settings.get "cellSize"
        width = @settings.get("width") * cellSize * 2
        height = @settings.get("height") * cellSize * 2
        @gridCtx.clearRect 0, 0, width, height   

        for x in [0..width] by cellSize
            @gridCtx.beginPath()
            @gridCtx.moveTo x - 0.5, 0
            @gridCtx.lineTo x - 0.5, width
            @gridCtx.stroke()
            for z in [0..height] by cellSize
                @gridCtx.beginPath()
                @gridCtx.moveTo 0, z - 0.5
                @gridCtx.lineTo height, z - 0.5 
                @gridCtx.stroke()
        
module.exports = View