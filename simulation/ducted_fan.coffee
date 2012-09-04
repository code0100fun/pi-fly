class DuctedFan
  maxThrust: 1.2 #kg
  maxPWM: 2500 # us positive pulse width
  minPWM: 500 # us positive pulse width
  pwm: 0
  constructor: ->
    @pwm = @minPWM
  thrust: ->
    # TODO: this should take thrust curve into account
    # calculate what the thrust from fan would be for the current pulse width
    percent = (@pwm - @minPWM) / (@maxPWM - @minPWM)
    @maxThrust * percent

module.exports = DuctedFan

