class Model
  outline: 0x000000
  fill: 0xff0000
  createMesh: ->
    THREE.SceneUtils.createMultiMaterialObject(@createGeometry(), [
      @createOutlineMaterial(@outline),
      @createFillMaterial(@fill)])
  createOutlineMaterial: (color)->
    new THREE.MeshBasicMaterial(
        color: color
        shading: THREE.FlatShading
        wireframe: true
        transparent: true)
  createFillMaterial: (color)->
    new THREE.MeshBasicMaterial({color: color}) 

class Tricopter extends Model
  buildMotor: (rotation) ->
    motor = new Motor(80, 0, 0)
    boom = new Boom(47, 0, 0)
    vector = new Vector(80, 0, 0)
    motorGrp = new THREE.Object3D()
    group = new THREE.Object3D()
    motorGrp.add motor.mesh
    motorGrp.add vector.mesh
    group.add motorGrp
    group.add boom.mesh
    group.rotation.y = rotation
    { group:group, boom:boom, motor:motorGrp, vector: vector }
  constructor: ->
    group = new THREE.Object3D()

    # motor 1
    @motor1 = @buildMotor(Math.PI*(1/2)) # Math.PI(1/2) + 2*Math.PI(0/3)
    #@motor1.motor.rotation.x = Math.PI/4
    #@motor1.vector.setLength(100)
    group.add @motor1.group 
    # motor 2
    @motor2 = @buildMotor(Math.PI*(7/6)) # Math.PI(1/2) + 2*Math.PI(1/3)
    group.add @motor2.group 
    # motor 3
    @motor3 = @buildMotor(Math.PI*(11/6)) # Math.PI(1/2) + 2*Math.PI(2/3)
    group.add @motor3.group 

    # body
    body = new Body(0,0,0)
    bodyGrp = new THREE.Object3D()
    bodyGrp.add body.mesh
    group.add bodyGrp
    #group.position.y = -160
    @mesh = group
    

class Motor extends Model
  radius: 10
  height: 10
  fill: 0x222222
  createGeometry: ->
    new THREE.CylinderGeometry(@radius, @radius, @height, 16)
  constructor: (x, y, z)->
    @mesh = @createMesh()
    @mesh.position.x = x
    @mesh.position.y = y
    @mesh.position.z = z
    #@mesh.overdraw = true

class Boom extends Model
  width: 4
  length: 50
  fill: 0x333333
  createGeometry: ->
    new THREE.CubeGeometry(@length, @width, @width)
  constructor: (x, y, z)->
    @mesh = @createMesh()
    @mesh.position.x = x
    @mesh.position.y = y
    @mesh.position.z = z

class Body extends Model
  radius: 25
  height: 5
  fill: 0xCCCC33
  createGeometry: ->
    new THREE.CylinderGeometry(@radius, @radius, @height, 12)
  constructor: (x, y, z)->
    @mesh = @createMesh()
    @mesh.position.x = x
    @mesh.position.y = y
    @mesh.position.z = z
    #@mesh.overdraw = true

class Vector extends Model
  width: 10
  length: 20
  thickness: 3
  fill: 0x0000FF
  setLength: (length) ->
    return if length == 0
    scale = length/@length
    @length = length
    @bodyMesh.scale.y *= scale
    @bodyMesh.position.y = -(@y + @length/2 + @width/2)
    @mesh.position.y = -(@width + @length)
  createGeometry: ->
    head = new THREE.CylinderGeometry(@width, @width, @thickness, 3)
    head
  constructor: (x, y, z)->
    group = new THREE.Object3D()
    @body = new THREE.CubeGeometry(@width*0.7, @length, @thickness)
    @bodyMesh = THREE.SceneUtils.createMultiMaterialObject(@body, [
      @createOutlineMaterial(@outline),
      @createFillMaterial(@fill)])
    @y = y
    @bodyMesh.position.x = x
    @bodyMesh.position.y = -(y + @length/2 + @width/2)
    @bodyMesh.position.z = z

    mesh = @createMesh()
    mesh.position.x = x
    mesh.position.y = y
    mesh.position.z = z
    mesh.rotation.x = 3*Math.PI/2
    group.add mesh
    group.add @bodyMesh
    group.position.y = -(@width + @length)
    group.rotation.x = Math.PI

    @mesh = group

class Scene


class Simulation
  viewAngle: 45
  near: 0.1
  far: 10000
  constructor: (@options) ->
    @options ?= {}
    @options.el ?= $('body')
    @options.width ?= 800
    @options.height ?= 600
  init: =>
    @aspect = @options.width/@options.height
    @renderer = new THREE.WebGLRenderer()
    @camera = new THREE.PerspectiveCamera(@viewAngle,
                                          @aspect,
                                          @near,
                                          @far)

    @scene = new THREE.Scene()

    # the camera starts at 0,0,0 so pull it back
    @camera.position.z = 500
    @scene.add(@camera)

    @renderer.setSize(@options.width, @options.height)
    @options.el.append(@renderer.domElement)

    config =
      width: 360
      height: 360
      depth: 1080
      splitX: 6
      splitY: 6
      splitZ: 18
    
    blockSize = config.width/config.splitX
    
    geometry = new THREE.CubeGeometry(config.width, config.height, config.depth, 
                                      config.splitX, config.splitY, config.splitZ)

    material = new THREE.MeshBasicMaterial( { color: 0xffaa00, wireframe: true } )
    boundingBox = new THREE.Mesh(geometry, material)

    @scene.add(boundingBox)

    @tricopter = new Tricopter()
    @scene.add(@tricopter.mesh)

    @controls = new THREE.OrbitControls( @camera, @renderer.domElement )
    
    @renderer.render(@scene, @camera)
    @start()
  
  start: =>
   @animate()

  animate: =>
    @controls.update()
    @renderer.render(@scene, @camera)
    #@stats.update()
    window.requestAnimationFrame(@animate)


