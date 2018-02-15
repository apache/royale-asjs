var path = require('path');
var connect  = require('connect');
var static = require('serve-static');

var debugDirPath = path.join(process.cwd(), 'bin', 'js-debug');
var server = connect();
server.use(static(debugDirPath));
server.listen(3000);

var livereload = require('livereload');
var lrserver = livereload.createServer();

process.on('message', function(msg){
    console.log('Reloading browser');
    lrserver.refresh(debugDirPath);
});