Tricopter = require("../src/tricopter")
IMU = require("../src/imu")
PIDController = require("../src/pid_controller")
PWMController = require("../src/pwm_controller")
SocketServer = require("../src/socket_server")
WebServer = require("../src/web_server")
SimIMUReader = require("./sim_imu_reader")
SimPWMWriter = require("./sim_pwm_writer")

class Simulator
  constructor: ->
    simIMUReader = new SimIMUReader()
    simPWMWriter = new SimPWMWriter()
    imu = new IMU(simIMUReader)
    pwm = new PWMController(simPWMWriter)
    @tricopter = new Tricopter(imu, pwm)
    web = new WebServer()
    @socket = new SocketServer(web.server)
    web.start()

    # for monitoring I/O traffic
    pwm.on "update", @pwmChanged
    imu.on "changed", @imuChanged

  imuChanged: (state) =>
    @socket.sendState state

  pwmChanged: (state) =>
    @socket.sendPWM state

simulator = new Simulator()

