class IMUState
  constructor: (state) ->
    state ?= {}
    @update state
  update: (state) =>
    @roll = state.roll or 0
    @pitch = state.pitch or 0
    @yaw = state.yaw or 0
    @health = state.health or 255
    @latitude = state.latitude or 0
    @longitude = state.longitude or 0
    @altitude = state.altitude or 0
    @course = state.course or 0
    @speed = state.speed or 0
    @gps_fix = state.gps_fix or 0
    @satellite_count = state.satellite_count or 0
    @time_of_week = state.time_of_week or 0

module.exports = IMUState

