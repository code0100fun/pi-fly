Vector3 = require("../math/vector3")
Matrix3 = require("../math/matrix3")
Quaternion = require("../math/quaternion")

# Gravity
# Thrust
class Force 
  constructor: (position, vector) ->
    @position = position
    @vector = vector

class RigidBody
  constructor: ->
  # center of mass meters
  center: new Vector3()
  # rotation matrix in radians
  orientation: new Quaternion()
  # mass of the body in kiliograms
  mass: 1.0
  # motion of the body in meters per second (m/s)
  velocity: Vector3()
  # the kenetic energy of a body in kg m/s (Newtons)
  momentum: Vector3()
  # effect of angular velocity on rotation matrix 
  spin: new Quaternion()
  # w (omega) => rate of change of angular displacement (change in rotation matrix)
  # derived by multiplying the angular momentum by the inverse inertia tensor
  angularVelocity: new Vector3()
  # a (alpha) => rate of change of angular velocity
  angularAcceleration: new Vector3()
  # I => inertia tensor
  # calculated about center of mass
  inertiaTensor: new Matrix3()
  # L = Iw =>  product of a body's rotational inertia and rotational velocity 
  # about a particular axis (center of mass).
  # Sum (integration) of torque over time
  angularMomentum: new Vector3()
  # T (Tau bar) = dL/dt = I(dw/dt) = Ia => the rate of change of angular momentum or "moment of force"
  torque: new Vector3()
  # the forces acting on the body
  forces: []
  addPointForce: (force) ->
    force.offset = force.position.vsub(@center)
    force.torque = force.offset.cross(force.vector)
    @forces.push force
  # global forces (like gravity) are applied evenly to an object
  # so just use a point force acting on the center of mass
  addGlobalForce: (force) ->
    force.position = @center
    @addPointForce force
  update: ->  
    #
    @applyForces()
    @angularVelocity = @inertiaTensor.inverse().vmult(@angularMomentum)
    @orientation.normalize()

  # spin = new Quaternion(0, self.angularVelocity.x, self.angularVelocity.y, self.angularVelocity.z);
  # spin = spin.mult(self.orientation);
  # spin = spin.smult(0.5);
  applyForces: ->
    @forces.forEach (force) ->
      # θ'' = (R × T)/I
      @torque = @torque.vadd(force.torque.divide(@inertiaTensor))


module.exports.Force = Force
module.exports.RigidBody = RigidBody

