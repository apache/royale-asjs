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
var prompt = require('prompt');
var pjson = require('../package');

var constants = require('../dependencies/Constants');
var duc = require('../dependencies/DownloadUncompressAndCopy');

var FlashPlayerGlobal = module.exports = Object.create(events.EventEmitter.prototype);

var flashPlayerGlobalURL = pjson.org_apache_royale.flash_player_global_url;
var fileNameFlashPlayerGlobal = pjson.org_apache_royale.flash_player_global_file_name;
var flashPlayerGlobalPromptText = "\
Apache Royale SWF support uses the Adobe Flash Player's playerglobal.swc to build Adobe Flash applications.\n\
The playerglobal.swc file is subject to and governed by the\n\
Adobe Flash Player License Agreement specified here:\n\
http://wwwimages.adobe.com/content/dam/acom/en/legal/licenses-terms/pdf/Flash_Player_21_0.pdf,\n\
By downloading, modifying, distributing, using and/or accessing the playerglobal.swc file\n\
you agree to the terms and conditions of the applicable end user license agreement.\n\
\n\
In addition to the Adobe license terms, you also agree to be bound by the third-party terms specified here:\n\
http://www.adobe.com/products/eula/third_party/.\n\
Adobe recommends that you review these third-party terms.\n\
\n\
This license is not compatible with the Apache v2 license.\n\
Do you want to download and install the playerglobal.swc?\n\
This is a required component (y/n)";

FlashPlayerGlobal.promptForFlashPlayerGlobal = function()
{
    var schema = {
        properties: {
            accept: {
                description: flashPlayerGlobalPromptText.cyan,
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
            FlashPlayerGlobal.downloadFlashPlayerGlobal();
        }
        else
        {
            console.log('Aborting installation');
            FlashPlayerGlobal.emit('abort');
        }
    });
};

FlashPlayerGlobal.downloadFlashPlayerGlobal = function()
{
    console.log('Downloading playerglobal.swc from ' + flashPlayerGlobalURL + fileNameFlashPlayerGlobal);

    var downloadDetails = {
        url:flashPlayerGlobalURL,
        remoteFileName:fileNameFlashPlayerGlobal,
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:fileNameFlashPlayerGlobal,
        unzip:false
    };

    duc.on('installComplete', handleInstallComplete);
    duc.install(downloadDetails);

};

function handleInstallComplete(event)
{
    FlashPlayerGlobal.emit('complete');
}

FlashPlayerGlobal.install = function()
{
    FlashPlayerGlobal.promptForFlashPlayerGlobal();
};