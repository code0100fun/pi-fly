vows = require("vows")
assert = require("assert")
DuctedFan = require("../simulation/ducted_fan")

suite = vows.describe('ducted_fan')
suite.addBatch
  'A Ducted Fan':
    'with minimum pwm':
      topic: new DuctedFan()
      'has 0 thrust': (fan) ->
        assert.equal fan.thrust(), 0
    'with maximum pwm':
      topic: -> 
        f = new DuctedFan()
        f.pwm = f.maxPWM
        f
      'has max thrust': (fan) ->
        assert.equal fan.thrust(), fan.maxThrust

suite.export(module)