THREE = vendorRequire "Three"
vendorRequire "OrbitControls"

class View extends Backbone.View
    initialize: ->
        @settings = @options.settings
        @materials = @options.materials

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
        
        geometry = new THREE.CubeGeometry 1,1,1
        objects = []
        
        addCube = (cube) ->
            c = new THREE.Mesh geometry, new THREE.MeshBasicMaterial
                color: cube.color
            c.position.x = cube.pos.x + 0.5
            c.position.y = cube.pos.y + 0.5
            c.position.z = cube.pos.z + 0.5
            objects.push c
            scene.add c
            c

        blocks = {}
        Backbone.on "addBlock", (block) ->
            cube = addCube pos: block.pos, color: block.color
            blocks["#{block.pos.x}-#{block.pos.x}-#{block.pos.y}"] = cube
            
        camera.position.x = 0.4699905475499408        
        camera.position.y = 24.234059847603994
        camera.position.z = 45.13855837516265
        
        render = ->
            requestAnimationFrame render
            renderer.render scene, camera
            controls.update()
               
        render()

module.exports = View