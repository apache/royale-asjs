#!/usr/bin/env node
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

var fs = require('fs-extra');
var path = require('path');
var execSync = require('child_process').execSync;
var spawn = require('child_process').spawn;
var fork = require('child_process').fork;
//var server=require('node-http-server');
//var server = require('./server');
var chokidar = require('chokidar');
var open = require("open");
var livereload = require('livereload');

var args = require('yargs')
    .usage('Usage: royale <command>')
    .example('royale new my-royale-project', 'Creates a new Apache Royale project in the myFirstRoyaleProject directory')
    .example('royale serve:debug', 'Builds debug version and starts server on localhost:6000; also watches the directory for changes')
    .example('royale serve:release', 'Builds release version and starts server on localhost:6001')
    .help('h')
    .alias('h', 'help')
    .epilog('Email: users@royale.apache.org | Github: https://github.com/apache/royale-asjs')
    .argv;

const CREATE_NEW_PROJECT = 'new';
const SERVE_DEBUG = 'serve:debug';
const DEBUG_PORT = 3000;
const SERVE_RELEASE = 'serve:release';
const RELEASE_PORT = 3001;
const SOURCE_DIR_NAME = 'src';

var command = args._[0];
if(!args.help && !args.h) {
    switch (command) {
        case CREATE_NEW_PROJECT: {
            createNewProject();
            break;
        }
        case SERVE_DEBUG: {
            serveDebug();
            break;
        }
        case SERVE_RELEASE: {
            serveRelease();
            break;
        }
        default: {
            console.log('Unknown command.  Use -h option for help')
        }
    }
}


function createNewProject() {
    //Get project name.  If project name is missing, use a default one
    var projectName = args._[1] || 'my-royale-project';

    //Copy template project; create directories automatically
    var projectPath = path.join(process.cwd(), projectName);
    try {
        fs.copySync(path.join(__dirname, 'template'), projectPath);
        console.log('Successfully created new Apache Royale project: %s', projectName);
    } catch (err) {
        console.error(err)
    }
}

function serveDebug() {
    compileDebug();
    startDebugServer();
}

function compileDebug() {
    //Compile project in debug mode
    var command = 'mxmlc ' + path.join(process.cwd(), SOURCE_DIR_NAME , 'Main.mxml -debug=true');
    console.log('Compiling...');
    try {
        execSync(command);
    }
    catch(e) {
        console.error(e.message);
    }
    console.log('Finished compiling');
    updateIndex();
    watchFiles();
    openBrowser('http://localhost:' + DEBUG_PORT);
}

var debugServerRunning = false;
// Start server if it is not already running
function startDebugServer() {
    if(!debugServerRunning) {
        var command = 'node ' + path.join(__dirname, 'connect.js');
        console.log('Starting server on localhost:3000...');
        fork(path.join(__dirname, 'connect.js'));
    }
}

function updateIndex() {
    var debugDirPath = path.join(process.cwd(), 'bin', 'js-debug');
    //Rewrite index.html
    var indexHTML = fs.readFileSync(path.join(debugDirPath, 'index.html'), 'utf8');
    indexHTML = indexHTML.replace("</html>", '<script>\n' +
        '  document.write(\'<script src="http://\' + (location.host || \'localhost\').split(\':\')[0] +\n' +
        '  \':35729/livereload.js?snipver=1"></\' + \'script>\')\n' +
        '</script></html>');
    fs.writeFile(path.join(debugDirPath, 'index.html'), indexHTML);
}

var watchingFiles = false;
function watchFiles() {
    if(!watchingFiles) {
        watchingFiles = true;
        //Watch the SOURCE_DIR_NAME directory, recompile if anything changes
        var pathToWatch = path.join(process.cwd(), SOURCE_DIR_NAME);
        console.log('Watching the directory %s for changes...', pathToWatch);
        chokidar.watch(pathToWatch)
            .on('change',
                function(path){
                    console.log('Change detected... %s', path);

                    compileDebug();
                }
            );
    }
}

var browserOpened = false;
function openBrowser(url) {
    if(!browserOpened) {
        browserOpened = true;
        console.log('Opening browser: ', url);
        open(url);
    }
}

function serveRelease() {
    compileRelease();
    startReleaseServer();
}

function compileRelease() {
    //Compile project in release mode
    var command = 'mxmlc ' + path.join(process.cwd(), SOURCE_DIR_NAME , 'Main.mxml -debug=false');
    console.log('Compiling release build...');
    execSync(command);
    console.log('Finished compiling');
}

var releaseServerRunning = false;
function startReleaseServer() {
    if(!releaseServerRunning) {
        server.deploy(
            {
                port: RELEASE_PORT,
                root: path.join(process.cwd(), 'bin', 'js-release')
            },
            handleReleaseServerReady
        );
    }
}

function handleReleaseServerReady() {
    releaseServerRunning = true;
    console.log('Your Apache Royale app (release version) is running on localhost:%s', RELEASE_PORT);
    openBrowser('http://localhost:' + RELEASE_PORT);
}
