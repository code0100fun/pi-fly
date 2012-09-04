vows = require("vows")
assert = require("assert")
Vector3 = require("../math/vector3")
Matrix3 = require("../math/matrix3")
Quaternion = require("../math/quaternion")
EngineUnit = require("../simulation/engine_unit")

suite = vows.describe('engine_unit')
suite.addBatch
  'An Engine Unit':
    'with a default initializer':
      topic: new EngineUnit()
      'has a position at origin [0,0,0]': (engine) ->
        assert.deepEqual engine.position, new Vector3()
      'has a force of [0,0,0]': (engine) ->
        f = engine.force()
        assert.deepEqual f.vector, new Vector3()
    'with max thrust':
      topic: ->
        e = new EngineUnit()
        e.fan.pwm = e.fan.maxPWM
        e
      'has a force of [0,maxThrust,0]': (engine) ->
        f = engine.force()
        assert.deepEqual f.vector, new Vector3(0,engine.fan.maxThrust,0)
    'with no rotation and a tilt of 90 degrees':
      topic: ->
        o = new Quaternion()
        p = new Vector3(20,0,0)
        e = new EngineUnit(p, o)
        e.fan.pwm = e.fan.maxPWM
        e.tilt = Math.PI/2
        e
      'has a force of [0,0,maxThrust]': (engine) ->
        f = engine.force()
        assert f.vector.x < 0.0001 and f.vector.x > -0.0001
        assert f.vector.y < 0.0001 and f.vector.y > -0.0001
        assert.equal f.vector.z, engine.fan.maxThrust
    'with 90 degrees rotation and a tilt of 90 degrees':
      topic: ->
        o = new Quaternion()
        o.setFromAxisAngle new Vector3(0,1,0), Math.PI/2
        p = new Vector3(20,0,0)
        e = new EngineUnit(p, o)
        e.fan.pwm = e.fan.maxPWM
        e.tilt = Math.PI/2
        e
      'has a force of [-maxThrust,0,0]': (engine) ->
        f = engine.force()
        assert.equal f.vector.x, -engine.fan.maxThrust
        assert f.vector.y < 0.0001 and f.vector.y > -0.0001
        assert f.vector.z < 0.0001 and f.vector.z > -0.0001

    'with 45 degrees rotation and a tilt of 45 degrees':
      topic: ->
        o = new Quaternion()
        o.setFromAxisAngle new Vector3(0,1,0), Math.PI/4
        p = new Vector3(20,0,0)
        e = new EngineUnit(p, o)
        e.fan.pwm = e.fan.maxPWM
        e.tilt = Math.PI/4
        e
      'has a force of [-maxThrust,0,0]': (engine) ->
        f = engine.force()
        console.log f
        assert.equal f.vector.x, -engine.fan.maxThrust
        assert f.vector.y < 0.0001 and f.vector.y > -0.0001
        assert f.vector.z < 0.0001 and f.vector.z > -0.0001
suite.export(module)