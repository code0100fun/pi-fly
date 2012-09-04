EventEmitter = require("events").EventEmitter
IMUState = require("../src/imu_state")

class SimIMUReader extends EventEmitter
  test: 'test'
  constructor: ->
    @intervalId = setInterval @emitSimData, 100
  state: new IMUState()
  serializeState: ->
    "!*** stuff ****"
  emitSimData: =>
    @emit "data", @serializeState()
  updateState: (state) ->

module.exports = SimIMUReader

