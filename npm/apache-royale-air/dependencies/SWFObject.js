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
var unzip = require('unzip');
var mkdirp = require('mkdirp');
var pjson = require('../package');

var constants = require('../dependencies/Constants');

var SWFObject = module.exports = Object.create(events.EventEmitter.prototype);

//SWFObject
var swfObjectURL = pjson.org_apache_royale.swf_object_url;
var fileNameSwfObject = pjson.org_apache_royale.swf_object_file_name;

SWFObject.downloadSwfObject = function()
{
    var downloadURL = swfObjectURL + fileNameSwfObject;
    console.log('Downloading SWFObject from ' + downloadURL);
    request
        .get(downloadURL)
        .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameSwfObject)
            .on('finish', function(){
                console.log('SWFObject download complete');
                extract();
            })
    );
};

function extract()
{
    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'templates/swfobject');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }
    console.log('Extracting SWFObject');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameSwfObject)
        .pipe(unzip.Parse())
        .on('entry', function (entry) {
            var fileName = entry.path;
            var type = entry.type; // 'Directory' or 'File'
            var size = entry.size;
            if (fileName === 'swfobject-2.2/swfobject/expressInstall.swf') {
                entry.pipe(fs.createWriteStream(constants.FLEXJS_FOLDER + 'templates/swfobject/expressInstall.swf'));
            }
            else if(fileName === 'swfobject-2.2/swfobject/swfobject.js') {
                entry.pipe(fs.createWriteStream(constants.FLEXJS_FOLDER + 'templates/swfobject/swfobject.js'));
            }
            else {
                entry.autodrain();
            }
        })
        .on('finish', function(){
            console.log('SWFObject extraction complete');
            SWFObject.emit('complete');
        })

}

SWFObject.install = function()
{
    SWFObject.downloadSwfObject();
};