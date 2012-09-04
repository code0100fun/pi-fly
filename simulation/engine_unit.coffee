DuctedFan = require("./ducted_fan")
Vector3 = require("../math/vector3")
Matrix3 = require("../math/matrix3")
Quaternion = require("../math/quaternion")
Force = require("./physics").Force

class EngineUnit
  @tiltAxis: new Vector3(1,0,0) # x-axis
  @thrustAxis: new Vector3(0,1,0) # y-axis
  tilt: 0
  constructor: (position, orientation) ->
    @position = new Vector3()
    @orientation = new Quaternion()
    position.copy @position if position?
    orientation.copy @orientation if orientation?
    @fan = new DuctedFan()
  force: => 
    # create tilt rotation matrix
    t = new Quaternion()
    t.setFromAxisAngle EngineUnit.tiltAxis, @tilt
    t = @orientation.mult t
    #t = t.mult @orientation
    # multiply force vector by rotation matrix
    v = t.vmult EngineUnit.thrustAxis.mult @fan.thrust()
    #v = @orientation.vmult t.vmult EngineUnit.thrustAxis.mult @fan.thrust()
    new Force @position, v

module.exports = EngineUnit

