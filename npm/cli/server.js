var express = require('express');
var http = require('http');
var path = require('path');
var reload = require('reload');
var logger = require('morgan');
var app = express();
var fs = require('fs-extra');
var chokidar = require('chokidar');

var debugServer = module.exports = Object.create(null);
debugServer.startDebugServer = function(p, port) {
    //Rewrite index.html
    var indexHTML = fs.readFileSync(path.join(p,'index.html'), 'utf8');
    indexHTML = indexHTML.replace("</html>", '<script src="/reload/reload-client.js"></script></html>');
    fs.writeFile(path.join(p,'index.html'), indexHTML);

    //Start server
    app.set('port', port);
    app.use(logger('dev'));
    app.use(express.static(p));
    var server = http.createServer(app);
    var reloadServer = reload(app);

    //Watch and reload
    chokidar.watch(p)
        .on('change',
            function(event, path){
                console.log('Change detected...');
                reloadServer.reload();
            }
        );

    server.listen(app.get('port'), function () {
        console.log('Web server listening on port ' + app.get('port'))
    })
}
