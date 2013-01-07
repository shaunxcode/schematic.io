THREE = vendorRequire "Three"
vendorRequire "OrbitControls"

class View extends Backbone.View
    events: 
        "mouseenter": "enableControls"
        "mouseleave": "disableControls"

    enableControls: ->
        @controls.enable()

    disableControls: ->
        @controls.disable()

    initialize: ->
        @geometry = new THREE.CubeGeometry 1,1,1
        @blocks = {}

    addBlock: (block) ->
        bid = "#{block.pos.x}x#{block.pos.z}x#{block.pos.y}"

        material = new THREE.MeshLambertMaterial
            color: parseInt "0x#{block.color}"
            ambient: 0x00ff80
            shading: THREE.FlatShading
            map: THREE.ImageUtils.loadTexture "/img/textures/cube.png"

        c = new THREE.Mesh @geometry, material
        c.position.x = block.pos.x + 0.5
        c.position.y = block.pos.y + 0.5
        c.position.z = block.pos.z + 0.5
        c.blockPos = block.pos

        @scene.add c
        @blocks[bid] = c
        c

    clearBlock: (block) ->
        if b = @blocks["#{block.pos.x}x#{block.pos.z}x#{block.pos.y}"]
            @scene.remove b
            delete @blocks["#{block.pos.x}x#{block.pos.z}x#{block.pos.y}"]

    _byLayer: (layer, cb) ->
        for i in [@scene.__objects.length - 1..0] by -1
            obj = @scene.__objects[i]
            if obj?.blockPos?.y is layer
                cb obj

    clearLayer: (layer) ->
        @_byLayer layer, (obj) => @scene.remove obj

    showLayer: (layer) ->
        @_byLayer layer, (obj) -> obj.visible = true

    hideLayer: (layer) ->
        @_byLayer layer, (obj) -> obj.visible = false

    clearCells: (artifact) ->
        points = {}
        for point in artifact.getPoints()
            points["#{point.x}x#{point.z}"] = true

        console.log @scene.__objects.length
        @_byLayer artifact.get("layer"), (obj) =>
            if obj?.blockPos? and points["#{obj.blockPos.x}x#{obj.blockPos.z}"]?
                @clearBlock pos: obj.blockPos

    render: ->
        size = @settings.get "size"

        scene = new THREE.Scene
        camera = new THREE.PerspectiveCamera 60, 500 / 500 , 1, 1000
        geometry = new THREE.Geometry

        for i in [-size..size] by 1
            geometry.vertices.push new THREE.Vector3 -size, 0, i
            geometry.vertices.push new THREE.Vector3 size, 0, i 
            geometry.vertices.push new THREE.Vector3 i, 0, -size 
            geometry.vertices.push new THREE.Vector3 i, 0,  size 

        material = new THREE.LineBasicMaterial color: 0x000000, opacity: 0.5
        line = new THREE.Line geometry, material 
        line.type = THREE.LinePieces
        scene.add line 
                    
                    
        controls = new THREE.OrbitControls camera 
        controls.disable()

        renderer = new THREE.WebGLRenderer
        renderer.setSize 500, 500
        @$el.html renderer.domElement
        
        camera.position.x = 0.4699905475499408        
        camera.position.y = 24.234059847603994
        camera.position.z = 45.13855837516265
        
        ambientLight = new THREE.AmbientLight Math.random() * 0x10 
        scene.add ambientLight 

        directionalLight = new THREE.DirectionalLight 0xffffff 
        directionalLight.position.normalize()
        scene.add directionalLight 


        render = =>
            requestAnimationFrame render
            renderer.render scene, camera
            controls.update()
            directionalLight.position = controls.object.position

        render()

        @scene = scene
        @controls = controls
        @camera = camera
        @renderer = renderer
        @listenTo Backbone, "AppResized", @resizeCanvas
        @resizeCanvas()

        @listenTo Backbone, "preview:addBlock", @addBlock
        @listenTo Backbone, "preview:clearBlock", @clearBlock
        @listenTo Backbone, "preview:removeLayer", @clearLayer
        @listenTo Backbone, "preview:showLayer", @showLayer
        @listenTo Backbone, "preview:hideLayer", @hideLayer
        @listenTo Backbone, "preview:clearCells", @clearCells

    resizeCanvas: ->
        width = @$el.width()
        height = @$el.height()
        @camera.aspect = width / height
        @camera.updateProjectionMatrix()
        @renderer.setSize width, height

module.exports = View