http = require("http")
fs = require("fs")
nodeStatic = require('node-static')
util = require('util')

class WebServer
  webroot: './src/public'
  constructor: ->
    file = new(nodeStatic.Server)(@webroot, {
      cache: 600,
      headers: { 'X-Powered-By': 'node-static' }
    })
    @server = http.createServer (request, response) ->
      request.addListener 'end', ->
        file.serve request, response, (err, result) ->
          if (err)
            console.error('Error serving %s - %s', request.url, err.message)
            if (err.status == 404 || err.status == 500)
              file.serveFile(util.format('/%d.html', err.status), err.status, {}, request, response);
            else
              response.writeHead(err.status, err.headers)
              response.end()
          else 
            console.log('%s - %s', request.url, response.message)
  start: ->
    @server.listen 8000


module.exports = WebServer

