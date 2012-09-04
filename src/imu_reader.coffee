EventEmitter = require("events").EventEmitter
SerialPort = require("serialport") # for IMU communication

class IMUReader extends EventEmitter
  serialDevice: "/dev/ttyACM0"
  constructor: ->
    @serialport = new SerialPort.SerialPort(@serialDevice,
      parser: SerialPort.parsers.readline("\n")
    )
    @serialport.on "data", (data) =>
      @emit "data", data

module.exports = IMUReader

