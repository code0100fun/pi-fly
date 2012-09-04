EventEmitter = require("events").EventEmitter
SerialPort = require("serialport") # for hardware PWM controller communication

class PWMWriter extends EventEmitter
  serialDevice: "/dev/ttyACM0" # TODO - which port can I use
  constructor: ->    
    @serialport = new SerialPort.SerialPort(@serialDevice,
      parser: SerialPort.parsers.readline("\n")
    )
  update: (state) ->
    @emit "update", state

module.exports = SimPWMWriter

