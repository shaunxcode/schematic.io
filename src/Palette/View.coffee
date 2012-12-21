MaterialView = require "./Material"

class View extends Backbone.View
    events:
        "click .tools div": "selectTool"
        
    initialize: ->
        @settings = @options.settings
    
    selectTool: (e) ->
        tool = $(e.currentTarget)
        tool.siblings().removeClass "active"
        tool.addClass "active"
        @settings.set tool: tool.data "tool"

        
    render: ->
        @$materials = $ ".materials"
        @collection.each (material) =>
            materialView = new MaterialView
                settings: @settings
                model: material
                
            @$materials.append materialView.render().$el
            
        @$(".materials div").first().click()
        @$(".tools div").first().click()

module.exports = View