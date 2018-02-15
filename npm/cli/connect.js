////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

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