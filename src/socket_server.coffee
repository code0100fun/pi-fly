faye = require("faye")

#WebSocket = require('faye-websocket');
class SocketServer
  constructor: (server) ->
    @bayeux = new faye.NodeAdapter
      mount: "/faye"
      timeout: 45

    @bayeux.attach server

  sendState: (state) ->
    #console.log 'state: ', state
    @bayeux.getClient().publish "/imu", state

  sendPWM: (state) ->
    #console.log 'pwm: ', state
    @bayeux.getClient().publish "/pwm", state


module.exports = SocketServer

