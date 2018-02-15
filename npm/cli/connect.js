var path = require('path');
var connect  = require('connect');
var static = require('serve-static');
var fs = require('fs-extra');

var debugDirPath = path.join(process.cwd(), 'bin', 'js-debug');

var server = connect();
server.use(  static(debugDirPath));
server.listen(3000);

var livereload = require('livereload');
var lrserver = livereload.createServer();
lrserver.watch(debugDirPath);