EventEmitter = require("events").EventEmitter
IMUState = require("./imu_state")

class IMU extends EventEmitter
  constructor: (@reader, @options) ->
    @options ?= {}
    @state = new IMUState()
    @dRoll = 0.02
    @dPitch = 0.02
    @dYaw = 0.02
    @maxRot = Math.PI/32
    @reader.on "data", (data) =>
      try
        @state.roll += @dRoll
        @state.pitch += @dPitch
        @state.yaw += @dYaw

        @dYaw -= 0.001 if @state.yaw > @maxRot
        @dYaw += 0.001 if @state.yaw < -@maxRot

        @dRoll -= 0.001 if @state.roll > @maxRot
        @dRoll += 0.001 if @state.roll < -@maxRot

        @dPitch -= 0.001 if @state.pitch > @maxRot
        @dPitch += 0.001 if @state.pitch < -@maxRot

        #console.log "Raw IMU", data
        
        # parse IMU data packet into state object
        # var j = JSON.parse(data);
        # trigger change event
        @emit "changed", @state
      catch ex
        console.warn ex

module.exports = IMU

