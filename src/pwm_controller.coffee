EventEmitter = require("events").EventEmitter
PWMState = require("./pwm_state")

class PWMController extends EventEmitter
  DEFAULT_UPDATE: 100
  constructor: (@pwmWriter, @options) ->
    @state = new PWMState()
    @dirty = true
    @intervalId = setInterval @updateIfDirty, @DEFAULT_UPDATE
  motor1: (val) ->
    @pwmGetSet val, "motor1"
  motor2: (val) ->
    @pwmGetSet val, "motor2"
  motor3: (val) ->
    @pwmGetSet val, "motor3"
  yaw: (val) ->
    @pwmGetSet val, "yaw"
  pwmGetSet: (val, name) ->
    unless(val is undefined or val is NaN)
      @dirty = @state[name] isnt val
      @state[name] = val
    @state[name]
  updateIfDirty: =>
    @dPWM ?= 5
    @dYAW ?= 5
    @motor1(@motor1() + @dPWM)
    @motor2(@motor2() + @dPWM)
    @motor3(@motor3() + @dPWM)
    @dPWM = -5 if @motor1() > 2500
    @dPWM = 5 if @motor1() < 500
    @yaw(@yaw() + @dYAW)
    @dYAW = -5 if @yaw() > 2500
    @dYAW = 5 if @yaw() < 500
    @sendPWMUpdate() if @dirty
  sendPWMUpdate: ->
    # send update to PWM writer
    @pwmWriter.update @state # probably should clone pwm !!!
    @emit "update", @state
    @dirty = false

module.exports = PWMController

