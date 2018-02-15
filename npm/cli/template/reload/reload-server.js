var http = require('http')
var reload = require('../lib/reload')
var fs = require('fs')
var open = require('open')
var clc = require('cli-color')
var argv = require('minimist')(process.argv.slice(2))

var serveStatic = require('serve-static')
var finalhandler = require('finalhandler')
var URL = require('url-parse')

var port = argv._[0]
var dir = argv._[1]
var openBrowser = (argv._[2] === 'true')
var hostname = argv._[3]
var runFile = argv._[4]
var startPage = argv._[5]
var verbose = (argv._[6] === 'true')

var reloadOpts = {
  port: port,
  verbose: verbose,
  noExpress: true
}

var time
var reloadReturned

var serve = serveStatic(dir, {'index': ['index.html', 'index.htm']})

var server = http.createServer(function (req, res) {
  var url = new URL(req.url)
  var pathname = url.pathname.replace(/(\/)(.*)/, '$2') // Strip leading `/` so we can find files on file system

  var fileEnding = pathname.split('.')[1]

  if (fileEnding === 'html' || pathname === '/' || pathname === '') { // Server side inject reload code to html files
    if (pathname === '/' || pathname === '') {
      pathname = dir + '/' + startPage
    } else {
      pathname = dir + '/' + pathname
    }

    fs.readFile(pathname, 'utf8', function (err, contents) {
      if (err) {
        res.writeHead(404, {'Content-Type': 'text/plain'})
        res.end('File Not Found')
      } else {
        contents += '\n\n<!-- Inserted by Reload -->\n<script src="/reload/reload.js"></script>\n<!-- End Reload -->\n'

        res.setHeader('Content-Type', 'text/html')
        res.end(contents)
      }
    })
  } else if (pathname === 'reload/reload.js') { // Server reload-client.js file from injected script tag
    res.setHeader('Content-Type', 'text/javascript')

    res.end(reloadReturned.reloadClientCode())
  } else { // Serve any other file using serve-static
    serve(req, res, finalhandler(req, res))
  }
})

// Reload call and configurations. Stub app as it isn't used here
reloadReturned = reload(function () {}, reloadOpts, server)

server.listen(port, function () {
  if (!fs.existsSync(runFile)) {
    fs.writeFileSync(runFile)

    // If openBrowser, open the browser with the given start page above, at a hostname (localhost default or specified).
    if (openBrowser) {
      open('http://' + hostname + ':' + port)
    }
  } else {
    time = new Date()
    console.log(clc.green('Server restarted  at ' + time.toTimeString().slice(0, 8)))
  }
})
