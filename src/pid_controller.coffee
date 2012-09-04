# TODO - needs to be more abstract and reusable
class PIDController
  constructor: (@imu, @pwmController, @options) ->
    @options ?= {}
    @settings =
      motor1: 2500
      motor2: 2500
      motor3: 2500
      tail: 2500
    @imu.on 'changed', @update
    # TODO: implement PID controller
  update: (state) =>
    # update P,I,D
    # make cahnges to output
    @settings.motor1 += 1
    @settings.motor2 += 1
    @settings.motor3 += 1
    @settings.tail += 1
    @pwmController.update(@output())
  output: =>
    @settings # TODO: clone this!!

module.exports = PIDController

