class PWMState
  constructor: (state) ->
    state ?= {}
    @update state
  update: (state) =>
    @motor1 = state.motor1 or 500
    @motor2 = state.motor2 or 500
    @motor3 = state.motor3 or 500
    @yaw = state.yaw or 1500

module.exports = PWMState

