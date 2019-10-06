/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */


var request = require('request');
var fs = require('fs');
var events = require('events');
var unzip = require('unzipper');
var mkdirp = require('mkdirp');
var pjson = require('../package');
var prompt = require('prompt');

var constants = require('../dependencies/Constants');

var FlatUI = module.exports = Object.create(events.EventEmitter.prototype);

//FlatUI
var flatUIURL = pjson.org_apache_royale.flatui_url;
var fileNameFlatUI = pjson.org_apache_royale.flatui_file_name;
var promptText =
"Apache Royale includes an optional component set\n\
that uses fonts from designmodo.com.  The font\n\
files are subject to and governed by the\n\
Creative Commons Attribution-NonCommercial-NoDerivs 3.0\n\
Unported license: http://creativecommons.org/licenses/by-nc-nd/3.0/\n\
This license is not compatible with the Apache v2 license.\n\
Do you want to install the designmodo fonts?\n\
This is an optional component (y/n)";

FlatUI.prompt = function()
{
    var schema = {
        properties: {
            accept: {
                description: promptText.yellow,
                pattern: /^[YNyn\s]{1}$/,
                message: 'Please respond with either y or n'.red,
                required: true
            }
        }
    };
    prompt.start();
    prompt.get(schema, function (err, result) {
        if(result.accept.toLowerCase() == 'y')
        {
            FlatUI.downloadFlatUI();
        }
        else
        {
            console.log('Skipping FlatUI installation');
            FlatUI.emit('complete');
        }
    });
};

FlatUI.downloadFlatUI = function()
{
    var downloadURL = flatUIURL + fileNameFlatUI;
    console.log('Downloading FlatUI from ' + downloadURL);
    request
        .get(downloadURL)
        .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFlatUI)
            .on('finish', function(){
                console.log('FlatUI download complete');
                extract();
            })
        );
};

function extract()
{
    var fontsDir = 'frameworks/fonts/';
    try
    {
        mkdirp(constants.ROYALE_FOLDER + fontsDir);
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }
    console.log('Extracting FlatUI');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameFlatUI)
        .pipe(unzip.Parse())
        .on('entry', function (entry) {
            var fileName = entry.path;
            if (fileName === 'Flat-UI-2.2.2/fonts/glyphicons/flat-ui-icons-regular.eot') {
                entry.pipe(fs.createWriteStream(constants.ROYALE_FOLDER + fontsDir + 'flat-ui-icons-regular.eot'));
            }
            else if (fileName === 'Flat-UI-2.2.2/fonts/glyphicons/flat-ui-icons-regular.ttf') {
                entry.pipe(fs.createWriteStream(constants.ROYALE_FOLDER + fontsDir + 'flat-ui-icons-regular.ttf'));
            }
            else if (fileName === 'Flat-UI-2.2.2/fonts/glyphicons/flat-ui-icons-regular.svg') {
                entry.pipe(fs.createWriteStream(constants.ROYALE_FOLDER + fontsDir + 'flat-ui-icons-regular.svg'));
            }
            else if (fileName === 'Flat-UI-2.2.2/fonts/glyphicons/flat-ui-icons-regular.woff') {
                entry.pipe(fs.createWriteStream(constants.ROYALE_FOLDER + fontsDir + 'flat-ui-icons-regular.woff'));
            }
            else if (fileName === 'Flat-UI-2.2.2/README.md') {
                entry.pipe(fs.createWriteStream(constants.ROYALE_FOLDER + fontsDir + 'README.md'));
            }
            else {
                entry.autodrain();
            }
        })
        .on('finish', function(){
            console.log('FlatUI extraction complete');
            FlatUI.emit('complete');
        })

}

FlatUI.install = function()
{
    if(process.env.ACCEPT_ALL_ROYALE_LICENSES === 'true')
    {
        FlatUI.downloadFlatUI();
    }
    else {
        FlatUI.prompt();
    }
};