EventEmitter = require("events").EventEmitter
Vector3 = require("../math/vector3")
Matrix3 = require("../math/matrix3")
SimPWMController = require("./sim_pwm_controller")
RigidBody = require("./physics").RigidBody
Force = require("./physics").Force
EngineUnit = require("./engine_unit")

class SimTricopter extends EventEmitter
  radius: 40 #cm
  mass: 0.300 #kgrams
  constructor: (simPwmController) ->

    @angleDelta = (2 * Math.PI) / 3.0 #radians
    @inertiaTensor = new Matrix3([1, 0, 0, 0, 1, 0, 0, 2, 0])
    @inertiaTensor = @inertiaTensor.smult(Math.pow(@mass, 2) / 2)
    @rigidBody.inertiaTensor = @inertiaTensor
    simPwmController.on "update", @updatePhysics

    @rigidBody = new RigidBody()
    @engine1 = new EngineUnit(new Vector3(Math.cos(0), 0, Math.sin(0)))
    @engine2 = new EngineUnit(new Vector3(Math.cos(@angleDelta), 0, Math.sin(@angleDelta)))
    @engine3 = new EngineUnit(new Vector3(Math.cos(2 * @ngleDelta), 0, Math.sin(2 * @angleDelta)))

    @gravity = new Force(new Vector3(0, 0, 0), new Vector3(0, -1, 0))

    @rigidBody.addPointForce @motor1
    @rigidBody.addPointForce @motor2
    @rigidBody.addPointForce @motor3
    @rigidBody.addGlobalForce @gravity

  updatePhysics: (pwm) ->
    # deltaRoll = 0
    # deltaPitch = 0
    # deltaYaw = 0
    
    # # TODO: calculate pitch/roll/yaw change for pwm values
    # state.roll = state.roll + deltaRoll
    # state.pitch = state.pitch + deltaPitch
    # state.yaw = state.yaw + deltaYaw

module.exports = SimTricopter

