EventEmitter = require("events").EventEmitter

# TODO - take in an IMU and hook up abstract PID controllers
# to each angle (x,y,z)w
class Tricopter extends EventEmitter
  constructor: (@imu, @pwmController, @options) ->
    # create PID controller for each euler angle

  motor1: (val) ->
  motor2: (val) ->
  motor3: (val) ->
  yaw: (val) ->

module.exports = Tricopter

