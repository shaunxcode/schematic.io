vendorRequire "colorpicker/colorpicker"
vendorRequire "colorpicker/eye"
vendorRequire "colorpicker/utils"

class View extends Backbone.View
    events:
        "click .tools div": "selectTool"
    
    selectTool: (e) ->
        tool = $(e.currentTarget)
        tool.siblings().removeClass "active"
        tool.addClass "active"
        @settings.set tool: tool.data "tool"

        
    render: ->
        color = @settings.get("color").hex

        selectedColor = @$(".selectedColor").css(background: "##{color}")
        
        @$color = @$(".color").ColorPicker 
            color: color
            onChange: (hsb, hex, rgb) =>
                selectedColor.css background: "##{hex}" 
                @settings.set color: {hsb, hex, rgb}
                

        @$(".tools div").first().click()

module.exports = View