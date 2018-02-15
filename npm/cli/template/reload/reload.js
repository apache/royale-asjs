module.exports = function reload (app, opts, server) {
  // Requires
  var path = require('path')
  var fs = require('fs')

  // Parameters variables
  var httpServerOrPort
  var expressApp
  var verboseLogging
  var port
  var webSocketServerWaitStart

  // Application variables
  var RELOAD_FILE = path.join(__dirname, './reload-client.js')
  var reloadCode = fs.readFileSync(RELOAD_FILE, 'utf8')
  var route

  // Websocket server variables
  var ws = require('ws')
  var WebSocketServer = ws.Server
  var wss

  // General variables
  var socketPortSpecified
  var argumentZero = arguments[0]
  var reloadJsMatch
  var reloadReturn

  opts = opts || {}

  if (arguments.length > 0 && (typeof (argumentZero) === 'object' || typeof (argumentZero) === 'function')) {
    if (typeof (argumentZero) === 'object') { // If old arguments passed handle old arguments, the old arguments and their order were: httpServerOrPort, expressApp, and verboseLogging
      console.warn('Deprecated Warning: You supplied reload old arguments, please upgrade to the new parameters see: https://github.com/alallier/reload/tree/master#api-for-express')
      if (arguments.length < 2) {
        throw new TypeError('Lack of/invalid arguments provided to reload. It is recommended to update to the new arguments anyways, this would be a good time to do so.', 'reload.js', 7)
      }
      httpServerOrPort = argumentZero
      expressApp = arguments[1]
      verboseLogging = arguments[2]
      route = '/reload/reload.js'
    } else { // Setup options or use defaults
      expressApp = argumentZero
      port = opts.port || 9856
      webSocketServerWaitStart = opts.webSocketServerWaitStart
      route = opts.route

      if (route) {
        // If reload.js is found in the route option strip it. We will concat it for user to ensure no case errors or order problems.
        reloadJsMatch = route.match(/reload\.js/i)
        if (reloadJsMatch) {
          route = route.split(reloadJsMatch)[0]
        }

        /*
         * Concat their provided path (minus `reload.js` if they specified it) with a `/` if they didn't provide one and `reload.js. This allows for us to ensure case, order, and use of `/` is correct
         * For example these route's are all valid:
         * 1. `newRoutePath` -> Their route + `/` + reload.js
         * 2. `newRoutePath/` -> Their route + reload.js
         * 3. `newRoutePath/reload.js` -> (Strip reload.js above) so now: Their route + reload.js
         * 4. `newRoutePath/rEload.js` -> (Strip reload.js above) so now: Their route + reload.js
         * 5. `newRoutePathreload.js` -> (Strip reload.js above) so now: Their route + `/` + reload.js
         * 6. `newRoutePath/reload.js/rEload.js/... reload.js n number of times -> (Strip above removes all reload.js occurrences at the end of the specified route) so now: Their route + 'reload.js`
        */
        route = route + (route.slice(-1) === '/' ? '' : '/') + 'reload.js'
      } else {
        route = '/reload/reload.js'
      }

      verboseLogging = opts.verbose === true || opts.verbose === 'true' || false

      if (port) {
        socketPortSpecified = port
        httpServerOrPort = port
      }

      if (server) {
        socketPortSpecified = null
        httpServerOrPort = server
      }
    }
  } else {
    throw new TypeError('Lack of/invalid arguments provided to reload', 'reload.js', 7)
  }

  // Application setup
  if (verboseLogging) {
    reloadCode = reloadCode.replace('verboseLogging = false', 'verboseLogging = true')
  }
  reloadCode = reloadCode.replace('socketUrl.replace()', 'socketUrl.replace(/(^http(s?):\\/\\/)(.*:)(.*)/,' + (socketPortSpecified ? '\'ws$2://$3' + socketPortSpecified : '\'ws$2://$3$4') + '\')')

  if (!server) {
    expressApp.get(route, function (req, res) {
      res.type('text/javascript')
      res.send(reloadCode)
    })
  }

  if (!webSocketServerWaitStart) {
    startWebSocketServer()
  }

  // Websocket server setup
  function startWebSocketServer () {
    if (verboseLogging) {
      console.log('Starting WebSocket Server')
    }

    if (socketPortSpecified) { // Use custom user specified port
      wss = new WebSocketServer({ port: httpServerOrPort })
    } else { // Attach to server, using server's port. Kept here to support legacy arguments.
      wss = new WebSocketServer({ server: httpServerOrPort })
    }

    wss.on('connection', (ws) => {
      if (verboseLogging) {
        console.log('Reload client connected to server')
      }
    })
  }

  function sendMessage (message) {
    if (verboseLogging) {
      console.log('Sending message to ' + (wss.clients.size) + ' connection(s): ' + message)
    }

    wss.clients.forEach(function each (client) {
      if (client.readyState === ws.OPEN) {
        client.send(message)
      }
    })
  }

  reloadReturn = {
    'reload': function () {
      sendMessage('reload')
    },
    'startWebSocketServer': function () {
      if (webSocketServerWaitStart) {
        startWebSocketServer()
      }
    }
  }

  if (server) { // Private return API only used in command line version of reload
    reloadReturn.reloadClientCode = function () {
      if (server) {
        return reloadCode
      }
    }
  }

  return reloadReturn
}
