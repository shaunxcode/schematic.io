THREE = vendorRequire "Three"
vendorRequire "OrbitControls"

class View extends Backbone.View
    initialize: ->
        @settings = @options.settings
        @materials = @options.materials
        @geometry = new THREE.CubeGeometry 1,1,1
        @objects = []
        @blocks = {}
        @blocksByLayer = {}

    addBlock: (block) ->
        material = new THREE.MeshLambertMaterial color: block.color, shading: THREE.FlatShading, overdraw: true

        c = new THREE.Mesh @geometry, material
        c.position.x = block.pos.x + 0.5
        c.position.y = block.pos.y + 0.5
        c.position.z = block.pos.z + 0.5
        
        @objects.push c
        @scene.add c
        @blocksByLayer[block.pos.y] or= {}
        @blocks["#{block.pos.x}x#{block.pos.z}x#{block.pos.y}"] = c
        @blocksByLayer[block.pos.y] = c
        c

    clearBlock: (block) ->
        if b = @blocks["#{block.pos.x}x#{block.pos.z}x#{block.pos.y}"]
            @scene.remove b
            delete @blocks["#{block.pos.x}x#{block.pos.z}x#{block.pos.y}"]
            delete @blocksByLayer[block.pos.y]["#{block.pos.x}x#{block.pos.z}"]

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
                            
        renderer = new THREE.WebGLRenderer
        renderer.setSize 500, 500
        @$el.html renderer.domElement
        
        
        
        camera.position.x = 0.4699905475499408        
        camera.position.y = 24.234059847603994
        camera.position.z = 45.13855837516265
        
        ambientLight = new THREE.AmbientLight Math.random() * 0x10 
        scene.add ambientLight 

        directionalLight = new THREE.DirectionalLight 0xffffff 
        directionalLight.position.x = 0.4699905475499408  
        directionalLight.position.y = 24.234059847603994
        directionalLight.position.z = 45.13855837516265
        directionalLight.position.normalize()
        scene.add directionalLight 



        render = ->
            requestAnimationFrame render
            renderer.render scene, camera
            controls.update()
               
        render()

        @scene = scene
        @controls = controls
        @camera = camera
        @renderer = renderer
        @listenTo Backbone, "AppResized", @resizeCanvas
        @resizeCanvas()

        @listenTo Backbone, "preview:addBlock", @addBlock
        @listenTo Backbone, "preview:clearBlock", @clearBlock

    resizeCanvas: ->
        width = @$el.width()
        height = @$el.height()
        @camera.aspect = width / height
        @camera.updateProjectionMatrix()
        @renderer.setSize width, height

module.exports = View