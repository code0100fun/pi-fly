EventEmitter = require("events").EventEmitter

class SimPWMWriter extends EventEmitter
  constructor: ->
  update: (state) ->
    @emit "update", state

module.exports = SimPWMWriter

